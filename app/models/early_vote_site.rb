class EarlyVoteSite < ActiveRecord::Base
  has_one :precinct, :foreign_key => "precinct_number"
  has_one :team, :through => :precinct
  has_many :early_vote_site_dates

  acts_as_gmappable :lat => "lat", :lng => "lng"

  # build an address from street, city, and state attributes
  geocoded_by :gmaps4rails_address

  # store the fetched address in the full_address attribute
  reverse_geocoded_by :lat, :lng, :address => :gmaps4rails_address

  validates :lat, :presence => true, :uniqueness => {:scope => :lng, :message => "Address already exists or address is not valid. Please double check your values."}
  validates :lng, :presence => true

  before_create :populate_precinct_from_gis

  attr_accessible :site_name, :street_address, :city, :state, :zipcode, :county, :gotv_t1_count, :gotv_t2_count, :gotv_t3_count, :gotv_supp_count
  require 'csv'

  def gmaps4rails_address
    "#{self.street_address}, #{self.city}, #{self.state}, #{self.zipcode}"
  end

  def self.import_csv(file)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file, "r:ISO-8859-1") )[1..-1].each do |row|
      import_site_name = row[0]
      import_street_address = row[1]
      import_city = row[2]
      import_state = row[3]
      import_zipcode = row[4]
      import_county = row[5]
      puts "creating #{row[0]}\n"
      self.create!(:site_name => import_site_name, :street_address => import_street_address, :city => import_city,
        :state => import_state, :zipcode => import_zipcode, :county => import_county)
      sleep 2
    end
  end

  def calculate_and_update_counts
    gotv_t1 = 0
    gotv_t2 = 0
    gotv_t3 = 0
    gotv_supp = 0
    distance_threshold = 2.5
    voters = Voter.where("lat IS NOT NULL AND lng IS NOT NULL")
    voters.each do |voter|
      distance = Geocoder::Calculations.distance_between([self.lat, self.lng], [voter.lat, voter.lng])
      if (distance <= distance_threshold)
        if voter.gotv_tier.present?
          case voter.gotv_tier
          when "Tier1"
            gotv_t1 += 1
          when "Tier2"
            gotv_t2 += 1
          when "Tier3"
            gotv_t3 += 1
          when "NewReg"
            gotv_supp += 1
          end
        end
      end
    end
    self.update_attributes!(:gotv_t1_count => gotv_t1, :gotv_t2_count => gotv_t2, :gotv_t3_count => gotv_t3, :gotv_supp_count => gotv_supp)
  end

  private
  def populate_precinct_from_gis
    #if self.precinct_number.nil?
      puts "populating #{self.gmaps4rails_address}\n"
      point = Geocoder.coordinates(self.gmaps4rails_address)
      if point.present?
        sql = "SELECT prec AS precinct_number, county FROM #{self.state.downcase}_gis_shapefiles WHERE ST_Contains(geom, ST_Transform(ST_GeomFromText('POINT(#{point[1]} #{point[0]})', 4326), 3421)) = 't';"
        tmp = self.class.find_by_sql(sql)
        self.precinct_number = tmp.first.precinct_number
        self.county = tmp.first.county
      end
  end
#SELECT early_vote_sites.*,
#(gotv_t1_count + gotv_t2_count + gotv_t3_count + gotv_supp_count) AS gotv_total,
#teams.team_name, (organizers.first_name || ' ' || organizers.last_name) AS organizer_name,
#regions.region_name
#FROM early_vote_sites
#INNER JOIN precincts ON early_vote_sites.precinct_number = precincts.precinct_number
#INNER JOIN teams ON precincts.team_id = teams.id
#INNER JOIN organizers ON teams.organizer_id = organizers.id
#INNER JOIN regions ON organizers.region_id = regions.id
#ORDER BY county,site_name;
end

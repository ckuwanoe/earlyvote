class Site < ActiveRecord::Base
  has_one :precinct, :foreign_key => "precinct_number"
  has_one :team, :through => :precinct

  acts_as_gmappable :lat => "lat", :lng => "lng"

  # build an address from street, city, and state attributes
  geocoded_by :gmaps4rails_address

  # store the fetched address in the full_address attribute
  reverse_geocoded_by :lat, :lng, :address => :gmaps4rails_address

  validates :lat, :presence => true
  validates :lng, :presence => true

  before_create :populate_precinct_from_gis

  attr_accessible :site_name, :street_address, :city, :state, :zipcode, :organization_id

  require 'csv'

  def gmaps4rails_address
    "#{self.street_address}, #{self.city}, #{self.state}, #{self.zipcode}"
  end

  def self.import_csv(file)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file, "r:ISO-8859-1") )[1..-1].each do |row|
      import_organization_id = row[0]
      import_site_name = row[1]
      import_street_address = row[2]
      #import_city = row[2]
      import_state = "NV"
      import_zipcode = row[3]
      #import_county = row[5]
      puts "creating #{row[1]}\n"
      self.create!(:site_name => import_site_name, :street_address => import_street_address,
        :state => import_state, :zipcode => import_zipcode, :organization_id => import_organization_id)
      sleep 2
    end
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
        #self.lat = point[0]
        #self.lng = point[1]
      end
  end
end

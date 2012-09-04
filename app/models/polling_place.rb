class PollingPlace < ActiveRecord::Base
  has_many :precincts
  has_many :teams, :through => :precincts

  acts_as_gmappable :lat => "lat", :lng => "lng"

  # build an address from street, city, and state attributes
  geocoded_by :gmaps4rails_address

  # store the fetched address in the full_address attribute
  reverse_geocoded_by :lat, :lng, :address => :gmaps4rails_address

  validates :lat, :presence => true, :uniqueness => {:scope => :lng, :message => "Address already exists or address is not valid. Please double check your values."}
  validates :lng, :presence => true

  before_create :populate_precinct_from_gis

  attr_accessible :site_name, :street_address, :city, :state, :zipcode, :county, :precinct_number_located_in

  def gmaps4rails_address
    "#{self.street_address}, #{self.city}, #{self.state}, #{self.zipcode}"
  end

  def self.import_csv(file)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file, "r:ISO-8859-1") )[1..-1].each do |row|
      import_id = row[0]
      import_site_name= row[1].titleize
      unless row[1] == 'MAILING PRECINCT'
        import_street_address = row[2].titleize
        import_city = row[3].titleize
        import_state = row[4]
        import_zipcode = row[5]
        import_precinct_number = row[6]
        puts "creating #{row[1]}\n"
        polling_place = self.find_or_create_by_id_and_site_name_and_street_address_and_city_and_state_and_zipcode(import_id, import_site_name,import_street_address,import_city,
          import_state,import_zipcode)
        precinct = Precinct.find_by_precinct_number_and_county(import_precinct_number, 'Clark')
        precinct.update_attributes!(:polling_place_id => polling_place.id)
      end
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
        self.precinct_number_located_in = tmp.first.precinct_number
        self.county = tmp.first.county
      end
  end
end

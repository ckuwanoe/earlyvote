class Team < ActiveRecord::Base
  require 'csv'
  # attr_accessible :title, :body
  belongs_to :organizer
  has_many :precincts
  attr_accessible :team_name, :organizer_id
  validates :team_name, :presence => true, :uniqueness => {:scope => :organizer_id}
  validates :organizer_id, :presence => true

  scope :regions_join,
    joins("LEFT JOIN organizers ON teams.organizer_id = organizers.id LEFT JOIN regions ON organizers.region_id = regions.id")

  def self.by_region(state, region)
    regions_join
    if region > 0
      regions_join.where("regions.state = '#{state}' AND regions.id = #{region}")
    end
  end

  def self.get_region_by_team_id(team)
    regions_join.select("regions.id AS region_id").where("teams.id = #{team}").first.region_id.to_i
  end

  def self.update_csv(file, state)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file))[1..-1].each do |row|
      import_region = row[0].strip
      import_co = row[1].strip
      import_team = row[2].strip

      # have to check if there are dashes in name as placeholders because Coger and Steve are lazy assholes
      if import_co.match('-').nil?
        import_co_name = import_co.split(" ")
        import_first_name = import_co_name[0]
        import_last_name = import_co_name[1]
      else
        import_co_name = import_co.split("-")
        import_first_name = import_co_name[0]
        import_last_name = "#{import_co_name[1]}-#{import_co_name[2]}"
      end

      # check to see if region already exists in db - if not create it
      region = Region.find_or_create_by_region_name_and_state(import_region, state)
      unless region.nil?
        co = Organizer.find_or_create_by_region_id_and_first_name_and_last_name(region.id, import_first_name, import_last_name)
        unless co.nil?
          team = Team.find_by_team_name(import_team)
          if team.nil?
            team = Team.create!(:organizer_id => co.id, :team_name => import_team)
          else
            update = team.update_attributes!(:organizer_id => co.id)
          end
          puts "Updated #{team.team_name}\n"
        end
      end
    end
  end

  def self.import_csv(file, state)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file))[1..-1].each do |row|

      #set vars
      import_region = row[0].strip
      import_co = row[1].strip
      import_team = row[2].strip
      import_van_precinct_id = row[3].strip
      import_county = row[4].strip.to_s.capitalize
      import_precinct = row[5].strip
      # have to check if there are dashes in name as placeholders because Coger and Steve are lazy assholes
      if import_co.match('-').nil?
        import_co_name = import_co.split(" ")
        import_first_name = import_co_name[0]
        import_last_name = import_co_name[1]
      else
        import_co_name = import_co.split("-")
        import_first_name = import_co_name[0]
        import_last_name = "#{import_co_name[1]}-#{import_co_name[2]}"
      end

      # check to see if region already exists in db - if not create it
      region = Region.find_or_create_by_region_name_and_state(import_region, state)

      unless region.nil?
        co = Organizer.find_or_create_by_region_id_and_first_name_and_last_name(region.id, import_first_name, import_last_name)
        unless co.nil?
          team = Team.find_or_create_by_organizer_id_and_team_name(co.id, import_team)
          unless team.nil?
            precinct = Precinct.find_or_create_by_precinct_number_and_team_id_and_county_and_van_precinct_id_and_state(import_precinct, team.id, import_county, import_van_precinct_id, state)
            f.write "successfully imported row - #{row}" unless precinct.nil?
          end
        end
      end
    end
  end
end

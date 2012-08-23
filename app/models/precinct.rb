class Precinct < ActiveRecord::Base
  # attr_accessible :title, :body
  #set_primary_key :precinct_number
  belongs_to :team
  has_one :precinct_score, :foreign_key => 'precinct_number'
  belongs_to :polling_place
  attr_accessible :precinct_number, :team_id, :county, :van_precinct_id

  #self.primary_key = :precinct_number

  validates :precinct_number, :presence => true, :uniqueness => {:scope => :county}

end

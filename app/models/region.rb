class Region < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :organizers
  has_many :teams, :through => :organizers

  attr_accessible :region_name, :state
  validates :region_name, :presence => true, :uniqueness => {:scope => :state}
  validates :state, :presence => true

  NORTHERN_NV = ["R01 - Reno North", "R02 - Reno South", "Rural North"]
end

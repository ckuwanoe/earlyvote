class Organizer < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :region
  has_many :teams

  attr_accessible :first_name, :last_name, :region_id

  validates :region_id, :presence => true, :uniqueness => {:scope => [:first_name, :last_name]}
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end

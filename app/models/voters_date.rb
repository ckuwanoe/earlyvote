class VotersDate < ActiveRecord::Base
  belongs_to :voter
  attr_accessible :voter_id, :date, :early_vote_site_radius_count

end

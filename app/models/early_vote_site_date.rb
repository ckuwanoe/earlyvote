class EarlyVoteSiteDate < ActiveRecord::Base
  belongs_to :early_vote_site

  def calculate_and_update_counts
    gotv_t1 = 0
    gotv_t2 = 0
    gotv_t3 = 0
    gotv_new_reg = 0
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
            gotv_new_reg += 1
          end
        end
      end
    end
    self.update_attributes!(:gotv_t1_count => gotv_t1, :gotv_t2_count => gotv_t2, :gotv_t3_count => gotv_t3, :gotv_new_reg_count => gotv_new_reg)
  end
end

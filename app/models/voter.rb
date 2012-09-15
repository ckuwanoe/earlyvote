class Voter < ActiveRecord::Base
  attr_accessible :early_vote_site_radius_count, :proximity

  def near_ev_site?
    distance_threshold = 2.5
    early_vote_sites = EarlyVoteSite.all
    early_vote_sites.each do |evs|
      distance = Geocoder::Calculations.distance_between([self.lat, self.lng], [evs.lat, evs.lng])
      if distance <= distance_threshold
        return true
      end
    end
    return false
  end

  def self.update_all_proximity
    voters = self.where("lat IS NOT NULL AND lng IS NOT NULL AND gotv_tier IS NOT NULL")
    voters.each do |voter|
      if voter.near_ev_site?
        voter.update_attributes(:proximity => true)
      else
        voter.update_attributes(:proximity => false)
      end
    end
  end

  def self.calculate_proximity_and_group_by_tier
    shash = HashWithIndifferentAccess.new(:total => 0, :gotv_t1 => 0, :gotv_t2 =>0, :gotv_t3 => 0, :gotv_new_reg => 0)
    voters = self.where("lat IS NOT NULL AND lng IS NOT NULL AND gotv_tier IS NOT NULL")
    voters.each do |voter|
      if voter.near_ev_site?
        shash[:total] += 1
        case voter.gotv_tier
        when "Tier1"
          shash[:gotv_t1] += 1
        when "Tier2"
          shash[:gotv_t2] += 1
        when "Tier3"
          shash[:gotv_t3] += 1
        when "NewReg"
          shash[:gotv_new_reg] += 1
        end
        puts "Total is now: #{shash[:total]}\n"
      end
    end
    return shash
  end
end

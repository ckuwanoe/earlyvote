class EarlyVoteSiteDate < ActiveRecord::Base
  belongs_to :early_vote_site
  attr_accessible :early_vote_site_id, :date, :time_open, :time_close, :gotv_t1_count, :gotv_t2_count, :gotv_t3_count, :gotv_new_reg_count
  validates :early_vote_site_id, :presence => true
  require 'csv'

  def self.import_update_with_dates(file)
    f = File.new('tmp/import.log', "w")
    CSV.parse(File.open(file, "r:ISO-8859-1") )[1..-1].each do |row|
      import_site_name = row[0].strip
      import_street_address = row[2].strip
      import_city = row[3].strip
      import_state = row[4].strip
      import_zipcode = row[5].strip
      import_county = row[6].strip
      import_date = Date.strptime(row[7].strip, "%m/%d/%y").to_s("%Y-%m-%d")
      import_time_open = Time.zone.parse(row[8])
      import_time_close = Time.zone.parse(row[9])
      puts "updating #{row[0]}\n"
      early_vote_site = EarlyVoteSite.find_or_create_by_site_name_and_street_address_and_city_and_state_and_zipcode_and_county(
        :site_name => import_site_name, :street_address => import_street_address, :city => import_city,
        :state => import_state, :zipcode => import_zipcode, :county => import_county)
      early_vote_site_date = self.find_or_create_by_early_vote_site_id_and_date_and_time_open_and_time_close(
        :early_vote_site_id => early_vote_site.id, :date => import_date, :time_open => import_time_open, :time_close => import_time_close)
    end
  end

  def self.update_counts_on_all_locations
    # update sites
    early_vote_site_dates = self.order("date DESC")
    early_vote_site_dates.each do |ed|
      puts "updating #{ed.early_vote_site.site_name}\n"
      ed.calculate_and_update_counts
    end
  end

  def calculate_and_update_counts
    gotv_t1 = 0
    gotv_t2 = 0
    gotv_t3 = 0
    gotv_new_reg = 0
    distance_threshold = 2.5
    voters = Voter.where("lat IS NOT NULL AND lng IS NOT NULL")
    existing_voters = []
    voters.each do |voter|
      distance = Geocoder::Calculations.distance_between([self.early_vote_site.lat, self.early_vote_site.lng], [voter.lat, voter.lng])
#      if (distance <= distance_threshold)
#        voters_date = VotersDate.find_or_create_by_voter_id_and_date(:voter_id => voter.id, :date => self.date)
#        if voter.gotv_tier.present?
#          case voter.gotv_tier
#          when "Tier1"
#            gotv_t1 += 1
#            radius_count = voters_date.early_vote_site_radius_count + 1
#            voters_date.update_attributes!(:early_vote_site_radius_count => radius_count)
#          when "Tier2"
#            gotv_t2 += 1
#            radius_count = voters_date.early_vote_site_radius_count + 1
#            voters_date.update_attributes!(:early_vote_site_radius_count => radius_count)
#          when "Tier3"
#            gotv_t3 += 1
#            radius_count = voters_date.early_vote_site_radius_count + 1
#            voters_date.update_attributes!(:early_vote_site_radius_count => radius_count)
#          when "NewReg"
#            gotv_new_reg += 1
#            radius_count = voters_date.early_vote_site_radius_count + 1
#            voters_date.update_attributes!(:early_vote_site_radius_count => radius_count)
#          end
#        end
#      end
      if (distance <= distance_threshold)
        unless existing_voters.include?(voter.id)
          existing_voters << voter.id
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
    end
    self.update_attributes!(:gotv_t1_count => gotv_t1, :gotv_t2_count => gotv_t2, :gotv_t3_count => gotv_t3, :gotv_new_reg_count => gotv_new_reg)
  end
end

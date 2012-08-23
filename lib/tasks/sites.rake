namespace :sites do
  desc "importing in ev sites csv"
  task :import => :environment do
    EarlyVoteSite.import_csv("db/import/ev_locations_fixed.csv")
  end

  desc "updating all early vote sites"
  task :update_all => :environment do
    EarlyVoteSite.all.each do |early_vote_site|
      puts "updating #{early_vote_site.site_name} it may take several minutes to complete\n"
      early_vote_site.calculate_and_update_counts
    end
  end

  desc "importing in random sites csv"
  task :import_small_biz => :environment do
    Site.import_csv("db/import/small_biz.csv")
  end
end

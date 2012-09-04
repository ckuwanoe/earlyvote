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

  desc "importing in polling place sites csv"
  task :import_polling_places => :environment do
    PollingPlace.import_csv("db/import/polling_places-clark.csv")
  end

  desc "importing in early votes sites by date csv"
  task :import_early_vote_by_date => :environment do
    EarlyVoteSiteDate.import_update_with_dates("db/import/ev-by-date.csv")
  end

  desc "updating early votes sites by date"
  task :update_counts_on_all_locations => :environment do
    EarlyVoteSiteDate.update_counts_on_all_locations
  end

  desc "updating from team building csv"
  task :team_update=> :environment do
    import = Team.update_csv("#{Rails.root.to_s}/db/import/team_import-r14.csv", "NV")
  end
end

class CreateVoterDates < ActiveRecord::Migration
  def change
    create_table :voter_dates do |t|
      t.integer :voter_id
      t.date :date
      t.integer :early_vote_site_radius_count, default: 0
      t.timestamps
    end
  end
end

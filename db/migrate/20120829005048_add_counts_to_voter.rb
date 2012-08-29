class AddCountsToVoter < ActiveRecord::Migration
  def up
    add_column :voters, :early_vote_site_radius_count, :integer, default: 0
    add_column :voters, :created_at, :timestamp
    add_column :voters. :updated_at, :timestamp
  end

  def down
    add_column :voters, :early_vote_site_radius_count
    add_column :voters, :created_at
    add_column :voters. :updated_at
  end
end

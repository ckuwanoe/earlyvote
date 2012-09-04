class AddCountsToVoter < ActiveRecord::Migration
  def up
    add_column :voters, :early_vote_site_radius_count, :integer, default: 0
    add_column :voters, :created_at, :timestamp
    add_column :voters, :updated_at, :timestamp
    add_column :voters, :id, :primary_key
  end

  def down
    remove_column :voters, :early_vote_site_radius_count
    remove_column :voters, :created_at
    remove_column :voters, :updated_at
    remove_column :voters, :id
  end
end

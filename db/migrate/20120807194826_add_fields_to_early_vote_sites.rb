class AddFieldsToEarlyVoteSites < ActiveRecord::Migration
  def change
    add_column :early_vote_sites, :gotv_t1_count, :integer, :default => 0
    add_column :early_vote_sites, :gotv_t2_count, :integer, :default => 0
    add_column :early_vote_sites, :gotv_t3_count, :integer, :default => 0
    add_column :early_vote_sites, :gotv_supp_count, :integer, :default => 0
  end
end

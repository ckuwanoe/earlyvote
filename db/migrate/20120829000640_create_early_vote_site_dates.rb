class CreateEarlyVoteSiteDates < ActiveRecord::Migration
  def change
    create_table :early_vote_site_dates do |t|
      t.integer :early_vote_site_id
      t.date :date
      t.timestamp :time_open
      t.timestamp :time_close
      t.integer :gotv_t1_count, default: 0
      t.integer :gotv_t2_count, default: 0
      t.integer :gotv_t3_count, default: 0
      t.integer :gotv_new_reg_count, default: 0
      t.timestamps
    end
  end
end

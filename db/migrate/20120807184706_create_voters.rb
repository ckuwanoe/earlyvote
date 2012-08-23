class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :state_code
      t.integer :van_id
      t.float :lat
      t.float :lng
      t.string :gotv_tier
      t.timestamps
    end
  end
end

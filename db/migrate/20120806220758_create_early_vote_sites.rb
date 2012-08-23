class CreateEarlyVoteSites < ActiveRecord::Migration
  def change
    create_table :early_vote_sites do |t|
      t.string :site_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zipcode
      t.integer :precinct_number
      t.string :county
      t.float :lat
      t.float :lng
      t.boolean :gmaps
      t.timestamps
    end
  end
end

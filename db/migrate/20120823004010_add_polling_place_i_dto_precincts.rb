class AddPollingPlaceIDtoPrecincts < ActiveRecord::Migration
  def up
    add_column :precincts, :polling_place_id, :integer
  end

  def down
    remove_column :precincts, :polling_place_id
  end
end

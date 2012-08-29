class RenamingPollingPlaceCol < ActiveRecord::Migration
  def up
    rename_column :polling_places, :precinct_number, :precinct_number_located_in
  end

  def down
    rename_column :polling_places, :precinct_number_located_in, :precinct_number
  end
end

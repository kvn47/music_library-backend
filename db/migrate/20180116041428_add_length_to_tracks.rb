class AddLengthToTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :length, :integer
  end
end

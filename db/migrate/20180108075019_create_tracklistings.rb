class CreateTracklistings < ActiveRecord::Migration[5.1]
  def change
    create_table :tracklistings, id: false do |t|
      t.references :tracklist, foreign_key: true
      t.references :track, foreign_key: true
    end
  end
end

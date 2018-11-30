class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :title, null: false, index: true
      t.integer :year
      t.string :path
      t.string :cover
      t.references :artist, foreign_key: true
      t.string :mbid, index: true

      t.timestamps
    end
  end
end

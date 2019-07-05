class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.references :album, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :title, null: false
      t.string :path
      t.integer :size
      t.integer :length
      t.string :mb_id, index: true

      t.timestamps
    end
  end
end

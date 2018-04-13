class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.integer :number, null: false
      t.string :title, null: false
      t.string :path
      t.integer :size
      t.references :album, null: false, foreign_key: true

      t.timestamps
    end
  end
end

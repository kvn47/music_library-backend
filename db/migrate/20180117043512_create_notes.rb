class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.integer :position
      t.string :kind
      t.string :artist
      t.string :album
      t.string :download_url
      t.string :download_path
      t.date :release_date
      t.text :details

      t.timestamps
    end
  end
end

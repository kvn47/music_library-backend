class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name, null: false, index: {unique: true}
      t.string :path
      t.string :image

      t.timestamps
    end
  end
end

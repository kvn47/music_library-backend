class CreateTracksExports < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks_exports, id: false do |t|
      t.references :export_list, foreign_key: true
      t.references :track, foreign_key: true
    end
  end
end

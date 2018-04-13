class CreateExportLists < ActiveRecord::Migration[5.1]
  def change
    create_table :export_lists do |t|
      t.string :name, null: false
      t.bigint :size, null: false, default: 0
      t.integer :capacity
      t.string :destination_path

      t.timestamps
    end
  end
end

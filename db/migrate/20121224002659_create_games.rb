class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :barcode, :limit => 20
      t.integer :title_id
      t.integer :section_id, :default => 1
      t.boolean :checked_in, :default => true
      t.boolean :culled, :default => false
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end

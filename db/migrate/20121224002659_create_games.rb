class CreateGames < ActiveRecord::Migration
  def change
    create_table :games, {:id => false} do |t|
      t.string :barcode
      t.integer :title_id
      t.integer :loaner_id, :default => nil
      t.integer :section_id, :default => 1
      t.boolean :checked_in, :default => true
      t.boolean :returned, :default => false

      t.timestamps
    end
    execute "ALTER TABLE games ADD PRIMARY KEY (barcode);"
  end
end

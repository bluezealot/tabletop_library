class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :game_id
      t.string :text

      t.timestamps
    end
  end
end

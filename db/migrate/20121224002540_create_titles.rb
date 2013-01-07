class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title
      t.integer :publisher_id

      t.timestamps
    end
  end
end

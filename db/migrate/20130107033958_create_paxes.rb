class CreatePaxes < ActiveRecord::Migration
  def change
    create_table :paxes do |t|
      t.string :name
      t.date :start
      t.date :end
      t.string :location

      t.timestamps
    end
  end
end

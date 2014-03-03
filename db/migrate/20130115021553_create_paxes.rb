class CreatePaxes < ActiveRecord::Migration
  def change
    create_table :paxes do |t|
      t.string :name
      t.string :location
      t.date :start_date
      t.date :end_date
      t.boolean :current, :default => false

      t.timestamps
    end
  end
end

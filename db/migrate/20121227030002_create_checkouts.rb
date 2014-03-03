class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.integer :game_id
      t.integer :attendee_id
      t.integer :pax_id
      t.timestamp :check_out_time
      t.timestamp :return_time
      t.boolean :closed, :default => false

      t.timestamps
    end
  end
end

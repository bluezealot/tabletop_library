class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :barcode, :limit => 20
      t.string :first_name
      t.string :last_name
      t.boolean :enforcer, :default => false
      t.string :handle
      t.integer :pax_id

      t.timestamps
    end
  end
end

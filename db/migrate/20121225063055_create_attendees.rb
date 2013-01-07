class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees, {:id => false} do |t|
      t.string :barcode
      t.string :first_name
      t.string :last_name
      t.boolean :enforcer, :default => false
      t.string :handle

      t.timestamps
    end
    execute "ALTER TABLE attendees ADD PRIMARY KEY (barcode);"
  end
end

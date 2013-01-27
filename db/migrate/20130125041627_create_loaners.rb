class CreateLoaners < ActiveRecord::Migration
  def change
    create_table :loaners do |t|
      t.string :name
      t.string :contact
      t.string :phone_number

      t.timestamps
    end
  end
end

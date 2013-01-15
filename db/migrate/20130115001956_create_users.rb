class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
    User.create({user_name:"admin", password:"tabletop", password_confirmation:"tabletop"})
  end
end

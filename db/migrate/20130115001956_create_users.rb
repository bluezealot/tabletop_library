class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
    User.create({user_name:"admin", password:"tabletop", password_confirmation:"tabletop"})
    User.create({user_name:"su", password:"cloud9", password_confirmation:"cloud9"})
  end
end

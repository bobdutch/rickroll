class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :country, :gender
      t.integer :number_of_rolls, :age
      t.string :email
      t.string :password
      t.string :salt
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

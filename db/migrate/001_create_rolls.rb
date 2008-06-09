class CreateRolls < ActiveRecord::Migration
  def self.up
    create_table :rolls do |t|
      t.string :destination_url, :snip_url, :roll_url
      t.integer :probability, :hits_until_expired, :user_id
      t.datetime :expires_at
      t.boolean :expired, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :rolls
  end
end

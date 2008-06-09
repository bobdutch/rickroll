class CreateHits < ActiveRecord::Migration
  def self.up
    create_table :hits do |t|
      t.string :referrer
      t.integer :roll_id, :null => false
      t.integer :count, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :hits
  end
end

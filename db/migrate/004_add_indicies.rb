class AddIndicies < ActiveRecord::Migration
  def self.up
    add_index(:hits, [:roll_id, :referrer], :unique => true)
    add_index(:rolls, :user_id)
  end

  def self.down
    remove_index(:hits, [:roll_id, :referrer])
    remove_index(:rolls, :user_id)
  end
end

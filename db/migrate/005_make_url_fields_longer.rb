class MakeUrlFieldsLonger < ActiveRecord::Migration
  def self.up
    change_column :rolls, :destination_url, :string, :limit => 2083
    change_column :rolls, :roll_url, :string, :limit => 2083
  end

  def self.down
  end
end

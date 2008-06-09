# == Schema Information
# Schema version: 3
#
# Table name: users
#
#  id              :integer(11)     not null, primary key
#  name            :string(255)     
#  country         :string(255)     
#  gender          :string(255)     
#  number_of_rolls :integer(11)     
#  age             :integer(11)     
#  email           :string(255)     
#  password        :string(255)     
#  salt            :string(255)     
#  created_at      :datetime        
#  updated_at      :datetime        
#

class User < ActiveRecord::Base
  has_many :rolls
end

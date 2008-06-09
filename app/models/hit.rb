# == Schema Information
# Schema version: 3
#
# Table name: hits
#
#  id         :integer(11)     not null, primary key
#  referrer   :string(255)     
#  roll_id    :integer(11)     
#  count      :integer(11)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Hit < ActiveRecord::Base
end

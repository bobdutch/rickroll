# == Schema Information
# Schema version: 3
#
# Table name: rolls
#
#  id                 :integer(11)     not null, primary key
#  destination_url    :string(255)     
#  snip_url           :string(255)     
#  roll_url           :string(255)     
#  probability        :integer(11)     
#  hits_until_expired :integer(11)     
#  user_id            :integer(11)     
#  expires_at         :datetime        
#  expired            :boolean(1)      
#  created_at         :datetime        
#  updated_at         :datetime        
#

class Roll < ActiveRecord::Base
  URL_REGEX = URI::regexp(['http','https','ftp'])

  belongs_to :user
  has_many :hits, :dependent => :destroy

  validates_format_of [:destination_url, :roll_url], :with => URL_REGEX
  validates_format_of :snip_url, :with => URL_REGEX, :allow_blank => true 
  validates_inclusion_of :probability, :in => 1..100, :allow_nil => true, :message => "should be between in the range 1 to 100"
  validates_numericality_of :hits_until_expired, :allow_nil => true

  validate :rolliness

  protected
  def rolliness
    if expires_at? or probability? or hits_until_expired? or expired?
      true
    else
      errors.add "this roll", "needs a sneaky way of turning into a rickroll"
      false
    end
  end
end

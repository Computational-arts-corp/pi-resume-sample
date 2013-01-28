
class CitiesUser
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :date, :type => Time

  belongs_to :city
  belongs_to :user
  
  has_many :reports
  has_many :galleries
  
end

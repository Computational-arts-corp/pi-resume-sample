
class Venue

  include Mongoid::Document
  include Mongoid::Timestamps

  ##
  ## fields
  ##
  field :name, :type => String
  validates :name, :uniqueness => true, :allow_nil => false

  field :name_seo, :type => String
  validates :name_seo, :uniqueness => true, :allow_nil => false
  
  field :descr, :type => String
  
  field :is_trash, :type => Boolean, :default => false
  scope :fresh, where( :is_trash => false )
  scope :trash, where( :is_trash => true )

  field :is_public, :type => Boolean, :default => true
  scope :public, where( :is_public => true )
  scope :not_public, where( :is_public => false )

  field :is_feature, :type => Boolean, :default => false
  scope :features, where( :is_feature => true )
  scope :not_features, where( :is_feature => false )

  field :x, :type => Float
  field :y, :type => Float

  field :lang, :type => String, :default => 'en'

  ##
  ## referred relations
  ##
  belongs_to :city
  belongs_to :user

  has_one :profile_photo, :class_name => 'Photo', :inverse_of => :profile_venue

  has_many :reports
  has_many :galleries
  has_many :photos

  ##
  ## embedded relations
  ##

  embeds_many :newsitems
  embeds_many :features

  ##
  ## functions
  ##
  def self.list conditions = { :is_trash => false }
		out = self.where( conditions).order_by( :name => :asc )
		[['', nil]] + out.map { |item| [ item.name, item.id ] }
	end
  
end

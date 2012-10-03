
FactoryGirl.define do

  factory :report do
  
    name 'Report name'
    name_seo 'Report-name'
    created_at '2012-01-01'
    association :tag
    
  end

  factory :r1, :parent => :report do
    name 'blah blah'
    name_seo 'blah-blah'
    created_at '2012-01-01'
    
    after(:create) { |r| r.tag = Tag.where( :domain => 'test.local' ).first }
    
  end 

  factory :r2, :class => Report do
    name 'blah blah.2'
    name_seo 'blah-blah2'
    created_at '2012-02-01'
    
    after(:create) { |r| r.tag = Tag.where( :domain => 'test.local' ).first }
    
  end 

  factory :r3, :class => Report do
    name 'blah blah 3'
    name_seo 'blah-blah-3'
    created_at '2012-01-02'
    
    after(:create) { |r| r.tag = Tag.where( :domain => 'test.local' ).first }
    
  end
  
  factory :r4, :class => Report do
    name 'blah blah 4'
    name_seo 'blah-blah-4'
    created_at '2012-01-10'
    
    after(:create) { |r| r.tag = Tag.where( :name => 'Tag 2' ).first }
    
  end
  
  
end
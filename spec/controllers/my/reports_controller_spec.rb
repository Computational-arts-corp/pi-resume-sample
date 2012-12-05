#
#require 'spec_helper'
#
#
#describe My::ReportsController do
#  
#  before :each do
#    City.all.each { |c| c.remove }
#    Report.all.each { |c| c.remove }
#    Tag.all.each { |c| c.remove }
#    
#    @user = User.all[0]
#    
#    @city = FactoryGirl.create :rio
#    
#    @r1 = FactoryGirl.create :r1
#    @r1.city = @city
#    @r1.save
#    
#    @r9 = FactoryGirl.create :r9
#    @r9.city = @city
#    @r9.save
#    
#  end
#  
#  describe 'index' do
#    
#    it 'shows reports' do
#      sign_in @user
#      get :index
#      response.should be_success
#      
#      reports = assigns(:reports)
#      reports.each do |r|
#        assert_equal r.user, @user
#      end
#    end
#    
#  end
#  
#end
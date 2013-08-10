require 'spec_helper'
describe SitesController do
  render_views
  before :each do
    User.all.each { |f| f.remove }
    @user = FactoryGirl.create :user

    Report.all.each { |r| r.remove }
    @feature_pt_1 = FactoryGirl.create :feature_pt_1
    @feature_ru_1 = FactoryGirl.create :feature_ru_1

    @request.host = 'piousbox.com'
    setup_sites
    @site = Site.where( :domain => 'piousbox.com', :lang => 'en' ).first || Site.first
  end

  describe 'newsitems' do
    it 'GETs more newsitems' do
      get :newsitems
      response.should be_success
      response.should render_template( 'sites/newsitems' )
    end

    it 'gets newsitems next page' do
      false.should eql true # @TODO
    end
  end

  describe 'features' do
    it 'GETs features' do
      get :features
      response.should render_template( 'sites/features' )
      assigns(:features).should_not eql nil
      features = assigns(:features)
      features.each_with_index do |f, idx|
        unless features.length == idx+1
          f.weight.should >= features[idx+1].weight
          if f.weight != features[idx+1].weight
            f.created_at.should >= features[idx+1].created_at
          end
        end
      end
    end

    it 'displays all features' do
      n_features = Feature.all.length
      get :show, :domainname => 'piousbox.com'
      assigns(:features).length.should eql n_features
    end

    it 'displays partial' do
      f = Feature.new( :partial_name => 'ads/small_square_blue', :weight => 20 )
      @site.features << f 
      @site.save.should eql true
      get :show, :domainname => 'piousbox.com'
      assert_select('.ad-small-square-blue')
    end
  end

  describe 'show' do
    it 'GETs show, sets locale' do
      get :show, :domainname => 'piousbox.com'
      response.should render_template('sites/show')
      assigns(:locale).should_not be nil
    end

    it 'shows up' do
      get :show, :domainname => 'piousbox.com'
      response.should be_success
      assigns(:features).should_not eql nil
      assigns(:newsitems).should_not eql nil
    end

    it 'sets display_ads toggle' do
      get :show, :domainname => 'piousbox.com'
      assigns(:display_ads).should_not eql nil
    end

    it 'GETs json' do
      n = Newsitem.new :descr => 'Lalala'
      @site.newsitems << n
      @site.save
      @site.should_not eql nil

      get :show, :site_id => @site.id, :format => :json
      response.should be_success
      result = JSON.parse(response.body)
      result['features'].length.should eql 0
      result['newsitems'].length.should > 0
      result['newsitems'].each do |n|
        n['descr'].should_not eql nil
      end
    end
  end
  
end

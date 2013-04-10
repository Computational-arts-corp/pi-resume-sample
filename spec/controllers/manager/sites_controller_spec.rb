require 'spec_helper'
describe Manager::SitesController do
  render_views
  before :each do
    City.all.each { |c| c.remove }
    @city = FactoryGirl.create :rio
    @sf = FactoryGirl.create :sf

    User.all.each { |c| c.remove }
    @user = User.all[0]
    @admin = FactoryGirl.create :admin
    sign_in :user, @admin

    Tag.clear
    @tag = FactoryGirl.create :tag

    Report.all.each { |c| c.remove }
    @r1 = FactoryGirl.create :r1
    @r1.city = @city
    @r1.save
    @r9 = FactoryGirl.create :r9
    @r9.city = @city
    @r9.save

    Gallery.all.each { |g| g.remove }
    @g = Gallery.create :name => 'a', :galleryname => 'bb', :user => User.all[0]

    Venue.all.each { |d| d.remove }
    @venue = FactoryGirl.create :venue

    setup_sites
    @site = Site.all.first
  end

  describe 'show' do
    it 'should GET show' do
      (0...4).each do |i|
        @site.newsitems << Newsitem.new( :name => "Aaa #{i}" )
      end
      @site.save
      @site.newsitems.length.should eql 4
      get :show, :id => @site.id
      response.should be_success
      response.should render_template('manager/sites/show')
      assert_select('newsitems-list')
    end
  end

  describe 'edit' do
    it 'should GET edit' do
      get :edit, :id => @site.id
      response.should be_success
      response.should render_template('manager/sites/edit')
    end
  end

  describe 'newsitems' do
    it 'should be able to delete a newsitem' do
      sign_in :user, @admin
      @site = Site.all[0]

      n = Newsitem.new
      n.report = Report.all[0]
      @site.newsitems << n
      flag = @site.save
      flag.should eql true

      n_old = @site.newsitems.to_a.length
      n_old.should_not eql 0
      
      newsitems = @site.newsitems.all
      delete :newsitem_destroy, :site_id => @site.id, :newsitem_id => newsitems.first.id
      response.should be_redirect

      n = Site.find(@site.id).newsitems.to_a.length
      ( n +1 ).should eql n_old
    end
  end

  describe 'features' do
    it 'should be able to delete feature' do
      f = Feature.new :name => 'blah blah'
      @site.features.all.each { |r| r.remove }
      @site.features << f
      @site = Site.find @site.id
      @site.features.all.length.should eql 1
      delete :destroy_feature, :site_id => @site.id, :feature_id => @site.features.all.first.id
      @site = Site.find @site.id
      @site.features.all.length.should eql 0
    end
  end

  describe 'index' do
    it 'GETs index' do
      get :index
      response.should be_success
      response.should render_template('manager/sites/index')
    end
  end

  describe 'update' do
    it 'updates n_features' do
      post :update, :site => { :n_features => 11 }, :id => @site.id
      result = Site.find @site.id
      result.n_features.should eql 11
    end
  end

end

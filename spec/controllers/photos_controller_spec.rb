require 'spec_helper'
describe PhotosController do
  before :each do
    setup_users
    sign_in :user, @user

    Report.all.each { |c| c.remove }
    @r1 = FactoryGirl.create :r1
    @r9 = FactoryGirl.create :r9

    Gallery.all.each { |g| g.remove }
    @gallery = FactoryGirl.create :gallery
    @gallery.user = @user
    @g1 = FactoryGirl.create :g1
    @g1.user = @simple
    @g2 = FactoryGirl.create :g2
    @g2.user = @user
    [ @gallery, @g1, @g2 ].each do |g|
      g.save
    end
    
    Site.all.each { |r| r.remove }
    setup_sites
    @request.host = 'piousbox.com'
    
    Photo.all.each { |ph| ph.remove }
    @photo = FactoryGirl.create :photo
  end

  describe 'create' do
    it 'should save logged in' do
      n_old = Photo.all.length
      descr = '24twebfvsdfg'
      photo = { :descr => descr }
      post :create, :photo => photo
      n_new = Photo.all.length
      ( n_new - n_old ).should eql 1
      new_photo = Photo.where( :descr => descr ).first
      new_photo.class.name.should eql 'Photo'
      # new_photo.username.should eql @user.username
    end

    it 'should not save without recaptcha' do
      PhotosController.any_instance.expects(:verify_recaptcha).returns( false )
      sign_out :user
      @current_user = nil
      session[:current_user] = nil
      n_old = Photo.all.length
      photo = { :descr => '24twebfvsdfg' }
      post :create, :photo => photo
      n_new = Photo.all.length
      ( n_new - n_old ).should eql 0
    end

    it 'should save with recaptcha' do
      PhotosController.any_instance.expects(:verify_recaptcha).returns(true)
      sign_out :user
      n_old = Photo.all.length
      
      post :create, :photo => @photo.attributes
      n_new = Photo.all.length
      ( n_new - n_old ).should eql 1
    end

    it 'should add a newsitem to the site' do
      sign_in :user, @user
      site_n_newsitems = @site.newsitems.length
      post :create, :photo => { :descr => 'blah blah', :is_public => true, :create_newsitems => 1 }
      @site = Site.find @site.id
      ( @site.newsitems.length - 1 ).should eql site_n_newsitems
    end

    it 'should not add a newsitem to the site, if the box is unchecked' do
      sign_in :user, @user
      site_n_newsitems = @site.newsitems.length
      post :create, :photo => { :descr => 'blah blah', :is_public => true, :create_newsitems => 0 }
      @site = Site.find @site.id
      ( @site.newsitems.length ).should eql site_n_newsitems
    end

  end
  
  describe 'to newsitem' do
    it 'is put in newsitems of creator and viewer' do
      n_user_news = @user.newsitems.length
      n_simple_news = @simple.newsitems.length
      n_user_2_news = @user_2.newsitems.length
      session[:current_user] = @user

      photo = { :descr => 'lalala', :viewer_ids => [ @simple.id, @user_2.id ], :is_public => 1 }
      post :create, :photo => photo

      User.find(@user.id).newsitems.length.should eql(n_user_news + 1)
      User.find(@simple.id).newsitems.length.should eql(n_simple_news + 1)
      User.find(@user_2.id).newsitems.length.should eql(n_user_2_news + 1)
    end
  end

  describe 'new profile photo' do
    it 'should get new profile photo' do
      sign_in :user, @user
      my_galleries_length = Gallery.where( :user => @user ).length
      all_galleries_length = Gallery.all.length
      all_galleries_length.should_not eql my_galleries_length
      get :new, :is_profile => true, :locale => :en
      response.should be_success
      ( assigns( :galleries ).length - 1 ).should eql my_galleries_length # -1 because there is the empty gallery with no name, when you go gallery.list
    end

    it 'should post new profile photo' do
      @user.profile_photo.blank?.should eql true
      post :create, :photo => { :set_as_profile_photo => true, :name => 'aaa' }
      response.should be_redirect
      u = User.find @user.id
      u.profile_photo.name.should eql 'aaa'
    end
  end

  describe 'new photo' do
    it 'should GET new photo for a gallery for anon' do
      sign_out :user
      get :new, :gallery_id => @gallery.id, :locale => :en
      assert_response :success
      assert_template :new
    end

    it 'should GET new photo for a gallery for registered user' do
      sign_in :user, @user
      get :new, :gallery_id => @gallery.id, :locale => :en
      assert_response :success
      assert_template :new
    end
  end

end

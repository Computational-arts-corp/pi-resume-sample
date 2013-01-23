
require 'test_helper'

class Utils::SitemapsControllerTest < ActionController::TestCase

  setup do
    @request.host = 'cac.local'

    Report.clear

    Tag.clear
    Tag.create :name => 'WDZ', :name_seo => 'wdz', :domain => 'blog.wevdevzine.com'
    FactoryGirl.create :tag_sedux
    FactoryGirl.create :tag_travel
    FactoryGirl.create :tag_qxt

    User.clear
    @user = FactoryGirl.create :user
    @manager = FactoryGirl.create :manager

    @tag_cac = FactoryGirl.create :tag_cac
    @cac_1 = FactoryGirl.create :cac1

  end
 
  test 'pi sitemap' do
    @request.host = 'piousbox.com'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'sedux' do
    @request.host = 'blog.sedux.net'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'webdevzine' do
    @request.host = 'blog.webdevzine.com'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'ish' do
    @request.host = 'infiniteshelter.com'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'qxt' do
    @request.host = 'organizer.annesque.com'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'cac' do
    @request.host = 'computationalartscorp.com'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'travel' do
    @request.host = 'travel-guide.mobi'
    get :sitemap, :format => :xml
    assert_response :success
  end

  test 'pi sitemap in html' do
    @request.host = 'piousbox.com'
    get :sitemap, :format => :html
    assert_response :success, 'Todo: sitemap in HTML'
  end
  
end
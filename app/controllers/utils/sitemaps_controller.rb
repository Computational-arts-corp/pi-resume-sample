class Utils::SitemapsController < ApplicationController
  skip_authorization_check

  def sitemap
    case @domain
    when 'cac.local', 'computationalartscorp.com', 'blog.computationalartscorp.com'
      cac_sitemap
    when 'piousbox.com', 'pi.local'
      pi_sitemap
    when 'blog.sedux.local', 'blog.sedux.net'
      sedux_sitemap
    when 'blog.webdevzine.com', 'blog.webdevzine.local'
      webdevzine_sitemap
    when 'travel-guide.mobi', 'staging.travel-guidel.mobi', 'mobi.local'
      travel_guide_sitemap
    else
      default_sitemap
    end

    respond_to do |format|
      format.xml do
        headers['Content-Type'] = 'application/xml'
        render 'utils/sitemap', :layout => false
      end
      format.json do
        headers['Content-Type'] = 'text/json'
        json = {
          :cities => @cities
        }
        render :json => json
      end
    end
  end

  private

  def pi_sitemap
    @reports = []
    @galleries = []
    @tags = []

    @users = User.all

    # likely to be empty
    @cities = []

    @meta = [
      { :url => root_path },
      { :url => about_path },
      { :url => privacy_path }
    ]
  end

  def travel_guide_sitemap
    @reports = Report.all.where( :site => @site )
    @galleries = Gallery.all.where( :site => @site )

    # will likely remain empty for some time
    @tags = [] 
    @users = []

    @cities = City.all
    @venues = Venue.all

    @meta = [
             { :url => site_path(@site.domain) },
             { :url => cities_path }
            ]

  end

  def default_sitemap
    @reports = Report.all
    @galleries = Gallery.all
    @videos = []
    @tags = Tag.all
  end

  def webdevzine_sitemap
    tag = Tag.where( :domain => 'blog.webdevzine.com' ).first
    @reports = Report.all.where( :tag => tag )
    @galleries = Gallery.all.where( :tag => tag )
  end

  def sedux_sitemap    
    tag = Tag.where( :domain => 'blog.sedux.net' ).first
    @reports = Report.all.where( :tag => tag )
    @galleries = Gallery.all.where( :tag => tag )
  end

  def bss_sitemap
    meta = []
  end

  def processing_sitemap
    meta = []
  end

  def cac_sitemap
    tag = Tag.where( :name_seo => 'cac' ).first
    @reports = Report.all.where( :tag => tag )
    @galleries = Gallery.all.where( :tag => tag )

    paths = [
      '/',
      '/news',
      '/contact',
      '/services',
      '/portfolio',
      '/about-us',
      '/team'
    ]

    @urls = []
    paths.each do |p|
      @urls << { :path => p }
    end

    @urls.each do |u|
      if u[:last_modified].blank?
        u[:last_modified] = Time.now
      end
    end
  end

end


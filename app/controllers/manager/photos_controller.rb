
class Manager::PhotosController < Manager::ManagerController

  before_filter :set_lists, :only => [ :new, :edit, :update ]
  
  def destroy
    @photo = Photo.find params[:id]
    
    unless @photo.gallery.blank?
      galleryname = @photo.gallery.galleryname
      gid = @photo.gallery.id
    end

    @photo.is_trash = true

    if @photo.save
      flash[:notice] = 'Success'
    else
      flash[:error] = 'No Luck'
    end
    
    if galleryname.blank?
      redirect_to manager_photos_no_gallery_path
    else
      redirect_to manager_gallery_path(gid)
    end
    
  end

  def index
    @photos = Photo.all.fresh.order_by( :created_at => :desc ).page( params[:photos_page] )
    @galleries = Gallery.list
  end

  def new
    @photo = Photo.new
  end
  
  def move
    @photo = Photo.find params[:id]
    
    old_galleryname = @photo.gallery.galleryname
    
    g = Gallery.find(params[:photo][:gallery_id])
    @photo.gallery = g
    
    if @photo.save
      flash[:notice] = 'Success'
    else
      flash[:error] = 'No Luck'
      puts! @photo.errors
    end
    
    redirect_to manager_gallery_path(old_galleryname)
  end
  
  def no_gallery
    @photos = Photo.where( :gallery => nil, :report => nil, :city => nil, :profile_user => nil )
    render 'index'
    
  end

  def edit
    @photo = Photo.find params[:id]
  end

  def update
    @photo = Photo.find(params[:id])
    
    unless params[:photo][:report_id].blank?
      r = Report.find params[:photo][:report_id]
      r.photo = @photo
      r.save
    end

    unless params[:photo][:tag_id].blank?
      t = Tag.find params[:photo][:tag_id]
      t.photo = @photo
      t.save
    end
    
    if @photo.update_attributes params[:photo]
      flash[:notice] = 'Success'
      redirect_to manager_photos_path
    else
      flash[:error] = 'No Luck.'
      render :edit
    end
    
  end

  private

  def set_lists
    @galleries = Gallery.list
    @reports = Report.list
    @friends = User.list
    @tags = Tag.list
    @list_venues = Venue.list
    @list_users = User.list
    @cities = City.list
  end
  
end
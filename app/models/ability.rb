class Ability
  include CanCan::Ability
  def initialize(user)
    
    #
    # signed in user
    #
    unless user.blank?
      
      can [ :create, :new ], Gallery
      can [ :edit, :update ], Gallery do |g|
        g.user == user
      end

      can [ :upload, :driver, :set_profile_photo, :new_profile_photo ], Photo
      can [ :move, :edit, :update, :destroy, :show ], Photo do |photo|
        photo.user.id.to_s == user.id.to_s
      end
      can [ :show ], Photo do |photo|
        photo.viewer_ids.include? user.id || user == photo.user
      end

      can [ :new, :create, :search, :index, :my_index ], Report
      can [ :edit, :update ], Report do |r|
        r.user == user
      end
      
      can [ :organizer, :photos, :new_profile, :create_profile, :edit_profile, :update_profile ], User
      can [ :edit, :update, :update_profile ], User do |uu|
        uu == user
      end

      can [ :new, :create ], Video

    end    
    user ||= User.new
    
    ###
    ### applies to all users
    ###
    
    can [ :index, :search, :not_found, :set_show_style ], Gallery
    can [ :show ], Gallery do |g|
      g.is_public && !g.is_trash
    end

    # has to be outside user auth b/c the uploading component is ajax.
    can [ :new, :create, :index, :do_upload, :not_found ], Photo
    can [ :show ], Photo do |photo|
      photo.is_public && !photo.is_trash
    end
    
    can [ :index, :search, :not_found ], Report
    can [ :show ], Report do |r|
      r.is_public && !r.is_trash
    end
       
    can [ :show, :newsitems, :features ],  Site

    can [ :index ], Tag
    can [ :show ], Tag do |t|
      true
    end

    can [ :resume, :reports, :galleries, :report, :gallery,
      :sign_in, :sign_up, :sign_out, :logout,
      :index, :show, :not_found, :github, :about ], User
    can [ :report ], User do |r|
      r.is_public && !r.is_trash
    end
    
    can [ :index, :show, :view ], Video

  end
end



$(document).ready ->
  if $( ".Lcities" ).length > 0

    if $( ".ids" ).length > 0
      cityname = $('.ids').attr('cityname')
      # CanvasOps.cities_show_initialize(cityname)

    # U.models.venues = new Models.Venues( cityname )
    # U.models.reports = new Models.Reports( cityname )
    # U.models.galleries = new Models.Galleries( cityname )
    # U.models.videos = new Models.Videos( cityname )

    # U.views.cities.profile = new Views.Cities.Profile( cityname )
    # U.views.cities.calendar = new Views.Cities.Calendar()
    # U.views.cities.map = new Views.Cities.Map()

    # U.models.city = new Models.City( cityname )
    # U.views.cities.home = new Views.Cities.Home({ collection: U.models.city })
    # U.views.cities.right_menu = new Views.Cities.RightMenu({ collection: U.models.city })

    # U.views.galleries.index = new Views.Galleries.Index({ collection: U.models.galleries })
    # U.views.videos.index = new Views.Videos.Index({ collection: U.models.videos })
    # U.views.reports.index = new Views.Reports.Index({ collection: U.models.reports })
    # U.views.venues.index = new Views.Venues.Index({ collection: U.models.venues })
      
    MyApp.addInitializer (options) ->
      true

      # MyApp.right_menu.show U.views.cities.right_menu

      # if $("body#cities_profile").length > 0
      # MyApp.right_region.show U.views.cities.home

    MyApp.start

  if $("body#cities_index").length > 0

    CanvasOps.cities_index_initialize()

    feature_cities_selected = true

    if feature_cities_selected
      CanvasOps.homepage_feature_cities()
    else
      CanvasOps.homepage_all_cities()


    
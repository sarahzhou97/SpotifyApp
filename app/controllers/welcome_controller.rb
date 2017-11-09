

class WelcomeController < ApplicationController
require 'rspotify'
  def index
  end
  
  def start
  end

  def create_new_user
  	RSpotify::authenticate("313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c")
	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :spotify, "313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c", scope: 'user-read-email playlist-read-private user-library-read user-library-modify user-read-recently-played user-read-currently-playing user-read-birthdate'
	end
	rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])
	puts spotify_user.user_id
  	#get user's name, birthdate,user_id, image
  	#spotify_user = SpotifyUser.new(:user_id => rspotify_user.user_id :name =>rspotify_user.name :birthdate => rspotify_user.birthdate :image => rspotify_user.image)
  	#spotify_user.save
  	#tracks = spotify_user.saved_tracks

  end
end


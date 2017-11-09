
require 'rspotify'

class WelcomeController < ApplicationController

  def index
  	
  end
  
  def start
  end

  def create_new_user
  	#RSpotify::authenticate("313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c")
  	spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

	# rspotify_user = RSpotify::User.find('12925718')
	@playlists = spotify_user.playlists

	# for element in playlists do
 #  		puts element.name
	# end
  	#get user's name, birthdate,user_id, image
  	#spotify_user = SpotifyUser.new(:user_id => rspotify_user.user_id :name =>rspotify_user.name :birthdate => rspotify_user.birthdate :image => rspotify_user.image)
  	#spotify_user.save
  	#tracks = spotify_user.saved_tracks

  end
end


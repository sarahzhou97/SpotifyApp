
require 'rspotify'

class WelcomeController < ApplicationController

  def index
  	
  end
  
  def start
  end

  def create_new_user
  	#RSpotify::authenticate("313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c")
  	rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])

  	@spotify_user = SpotifyUser.new(:user_id => rspotify_user.id,:name =>rspotify_user.display_name)
	@spotify_user.save

	@playlists = rspotify_user.playlists(limit: 50)

	for playlist in @playlists do
  		play = Playlist.new(:playlist_id => playlist.snapshot_id,:creator_id => playlist.owner.id,:playlist_name => playlist.name)
  		play.save
	end

  	@tracks = rspotify_user.saved_tracks(limit: 50)

  	for track in @tracks do
  		t = Track.new(:album_id => track.album.id, :popularity => track.popularity,:track_id => track.id,:song_name => track.name, :artist => track.artists[0])
  		t.save
	end

	

  end
end


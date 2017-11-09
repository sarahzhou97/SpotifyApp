
require 'rspotify'

class WelcomeController < ApplicationController

  def index
  	
  end
  
  def start
  end

  def create_new_user
  	RSpotify::authenticate("313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c")
  	rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])

  	@spotify_user = SpotifyUser.new(:user_id => rspotify_user.id,:name =>rspotify_user.display_name)
  	@spotify_user.save

  	@playlists = rspotify_user.playlists(limit: 50)

  	for playlist in @playlists do
    		add_playlist(playlist,rspotify_user.id)
  	end

    @tracks = rspotify_user.saved_tracks(limit: 50)

    for track in @tracks do
    	add_song(track)
      saved = Saved.new(:user_id =>rspotify_user.id, :track_id => track.id)
      saved.save
  	end

  end

  def add_playlist(playlist,id)
    play = Playlist.new(:playlist_id => playlist.snapshot_id,:creator_id => playlist.owner.id,:playlist_name => playlist.name)
    play.save
    follows = FollowsPlaylist.new(:playlist_id => playlist.snapshot_id, :user_id => id)
    follows.save
    tracks = playlist.tracks
    for track in tracks do
      add_song(track)
      contains = PlaylistContain.new(:playlist_id => playlist.snapshot_id, :track_id => track.id)
      contains.save
    end
  end

  def add_album(album)
    alb = Album.new(:album_type =>album.album_type,:artist_id => album.artists[0].id, :album_id => album.id, :genre => album.genres[0], :album_name => album.name,:popularity => album.popularity, :release_date =>album.release_date)
    alb.save
  end

  def add_artist(artist)
    art = Artist.new(:name => artist.name, :artist_id => artist.id, :popularity => artist.popularity, :genre => artist.genres[0])
    art.save
  end

  def add_song(track)
    audio_features = RSpotify::AudioFeatures.find(track.id)
    t = Track.new(:album_id => track.album.id, :popularity => track.popularity,:track_id => track.id,:song_name => track.name, :artist_id => track.artists[0].id,
      :acousticness => audio_features.acousticness,:danceability => audio_features.danceability,
      :energy => audio_features.energy,:instrumentalness => audio_features.instrumentalness,:key => audio_features.key,:liveness => audio_features.liveness,:loudness => audio_features.loudness,
      :mode => audio_features.mode,:speechiness => audio_features.speechiness,:tempo => audio_features.tempo,:time_signature => audio_features.time_signature,:valence => audio_features.valence)
    t.save
    add_album(track.album)
    add_artist(track.artists[0])
  end

end



require 'rspotify'

class WelcomeController < ApplicationController

  $spotify_user

     $num = '3'
    $rec = 'Acousticness'



  def index
    
  end
  
  def start
  end

  def database_data
    run_queries_global($spotify_user.user_id)
  end

  def user_data
    run_queries_user($spotify_user.user_id)
  end

  def user_info
  end

  def user_preferences
  end

  def database_preferences
  end

  def preferences_submitted
     $num = params[:num]
    $rec = params[:rec]

  end

  def user_preferences
  end

  def create_new_user
  
    rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    if SpotifyUser.exists?(rspotify_user.id)
      $spotify_user = SpotifyUser.find(rspotify_user.id)
      
    else
      $spotify_user = SpotifyUser.new(:user_id => rspotify_user.id,:name =>rspotify_user.display_name, :country => rspotify_user.country)
      $spotify_user.save

       @playlists = rspotify_user.playlists(limit: 5)

      for playlist in @playlists do
          add_playlist(playlist,rspotify_user.id)
      end

    @tracks = rspotify_user.saved_tracks(limit: 18)

    for track in @tracks do
      add_song(track)
      saved = Saved.new(:user_id =>rspotify_user.id, :track_id => track.id)
      begin
        saved.save
      rescue 
      end
    end
    
    end


   

    render :user_info

  end

  def run_queries_global(id)

    @popularity = Track.average("popularity")
@danceability = Track.average("danceability")
@acousticness = Track.average("acousticness")
@instrumentalness = Track.average("instrumentalness")
@energy = Track.average("energy")
@liveness = Track.average("liveness")
@loudness = Track.average("loudness")
@speechiness = Track.average("speechiness")
@tempo = Track.average("tempo")
@valence = Track.average("valence")


top_n_tracks_overall_sql = 'select t1.track_id, t1.song_name, t1.name from
    (select saveds.track_id, tracks.song_name, artists.name, count(*) from saveds, tracks, artists
    where tracks.track_id=saveds.track_id and tracks.artist_id=artists.artist_id
    group by saveds.track_id, tracks.song_name, artists.name
    order by count desc) t1
  limit ' +$num+ '::bigint;'


@top_n_tracks_overall = ActiveRecord::Base.connection.execute(top_n_tracks_overall_sql)

top_n_playlists_overall_sql = 'select t1.playlist_id, t1.playlist_name from
    (select playlists.playlist_id, playlists.playlist_name, count(*) 
    from follows_playlists, playlists
    where follows_playlists.playlist_id = playlists.playlist_id
    group by playlists.playlist_id, playlists.playlist_name
    order by count desc) t1
  limit ' +$num+ '::bigint;'

  @top_n_playlists_overall = ActiveRecord::Base.connection.execute(top_n_playlists_overall_sql)

top_n_artists_overall_sql = 'select t1.artist_id, t1.name from
    (select artists.artist_id,artists.name, count(*) 
    from saveds, tracks, artists
    where saveds.track_id = tracks.track_id and artists.artist_id = tracks.artist_id
    group by artists.artist_id, artists.name
    order by count desc) t1
  limit ' +$num+ '::bigint;'

@top_n_artists_overall = ActiveRecord::Base.connection.execute(top_n_artists_overall_sql)

top_n_albums_overall_sql = 'select t1.album_name, artists.name
  from artists, (select album_name, albums.artist_id, count(*) as count
    from albums, tracks
    where albums.album_id=tracks.album_id
    group by album_name, albums.artist_id
    order by count desc) as t1
  where artists.artist_id=t1.artist_id
  group by t1.album_name, artists.name
limit ' +$num+ '::bigint;
'

@top_n_albums_overall=ActiveRecord::Base.connection.execute(top_n_albums_overall_sql)

top_n_albums_by_num_saved_overall_sql = 'select t1.album_name from
    (select albums.album_id, albums.album_name, count(*) as count
      from saveds, tracks, albums
      where saveds.track_id = tracks.track_id and albums.album_id = tracks.album_id
      group by albums.album_id, albums.album_name
      order by count desc
      ) as t1
  limit ' +$num+ '::bigint;'

  @top_n_albums_by_num_saved_overall=ActiveRecord::Base.connection.execute(top_n_albums_by_num_saved_overall_sql)


end


  def run_queries_user(id)


    @popularity_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("popularity")
@danceability_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("danceability")
@acousticness_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("acousticness")
@instrumentalness_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("instrumentalness")
@energy_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("energy")
@liveness_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("liveness")
@speechiness_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("speechiness")
@loudness_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("loudness")
@tempo_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("tempo")
@valence_user = Saved.where(user_id: id).joins("INNER JOIN tracks on saveds.track_id = tracks.track_id").average("valence")


  # users with same saved songs
    top_n_users_sql = 'select t2.user_id, name from (select t1.user_id from 
    (select saveds.user_id, name, count(*) 
    from saveds, spotify_users 
    where saveds.user_id<> ' +id+ '::varchar and saveds.track_id in 
    (select track_id from saveds where user_id = '+id+ '::varchar) and
    spotify_users.user_id = saveds.user_id
    group by saveds.user_id, name
    order by count desc) t1) as t2, spotify_users
    where spotify_users.user_id = t2.user_id
    limit ' +$num+ '::bigint;'

  # users with similar playlisted songs
    top_n_users_playlistsongs_sql = 'select t2.user_id, name from (select t1.user_id from 
    (select saveds.user_id, name, count(*) 
    from tracks, playlists, playlist_contains, spotify_users
    where saveds.user_id<> ' +id+ '::varchar and saveds.track_id in 
    (select track_id from saveds where user_id = '+id+ '::varchar) and
    spotify_users.user_id = saveds.user_id
    group by saveds.user_id, name
    order by count desc) t1) as t2, spotify_users
    where spotify_users.user_id = t2.user_id
    limit ' +$num+ '::bigint;'

    @top_n_users = ActiveRecord::Base.connection.execute(top_n_users_sql)

    top_n_albums_sql = 'select t1.album_id, t1.album_name, artists.name, count(*) from
    artists, (select albums.album_id,albums.album_name, albums.artist_id, s.track_id from 
      (select * from saveds where saveds.user_id = ' +id+ '::varchar) s, tracks, albums
      where albums.album_id = tracks.album_id and tracks.track_id=s.track_id
    ) t1
    where artists.artist_id=t1.artist_id
  group by t1.album_id,t1.album_name, artists.name
  order by count desc
  limit ' +$num+ '::bigint;'



  @top_n_albums = ActiveRecord::Base.connection.execute(top_n_albums_sql)

  top_n_artists_sql = 'select artists.artist_id, name, count(*) from
    (select * from saveds where saveds.user_id = '+id+ '::varchar) s, tracks, artists
    where artists.artist_id = tracks.artist_id and tracks.track_id=s.track_id
    group by artists.artist_id,artists.name
    order by count desc
  limit ' +$num+ '::bigint;'

  @top_n_artists = ActiveRecord::Base.connection.execute(top_n_artists_sql)

 top_n_songs_recs_sql = 'select tracks.song_name, artists.name
  from tracks, playlists, playlist_contains, artists,
    (select avg(tracks.'+$rec+') as attri
     from tracks, playlists, playlist_contains
     where (tracks.track_id=playlist_contains.track_id  and playlists.creator_id='+id+'::varchar and playlists.playlist_id=playlist_contains.playlist_id)) as t1
  where ((tracks.track_id=playlist_contains.track_id  and playlists.creator_id<>'+id+'::varchar and playlists.playlist_id=playlist_contains.playlist_id)) and (tracks.artist_id=artists.artist_id)
    group by tracks.song_name, artists.name, tracks.'+$rec+', t1.attri
    order by abs(t1.attri-tracks.'+$rec+') ASC
    limit ' +$num+ '::bigint;'

    puts top_n_songs_recs_sql

  @top_n_songs_recs = ActiveRecord::Base.connection.execute(top_n_songs_recs_sql)



top_n_users_1_sql = 'select t1.creator_id, spotify_users.name from
(select creator_id from
    (select creator_id, count(*)
      from playlists
      where playlists.creator_id <>'+id+'::varchar and playlists.playlist_id in
        (select follows_playlists.playlist_id from follows_playlists where '+id+ '::varchar = follows_playlists.user_id)
      group by creator_id
      order by count desc) as foo) as t1, spotify_users
      where t1.creator_id = spotify_users.user_id
  limit ' +$num+ '::bigint;'

  @top_n_users_1 = ActiveRecord::Base.connection.execute(top_n_users_1_sql)

top_n_users_2_sql = 'select t1.user_id, name from (select user_id from
    (select user_id, count(*)
      from follows_playlists
      where follows_playlists.user_id <> '+id+ '::varchar and follows_playlists.playlist_id in
        (select playlists.playlist_id from playlists where '+id+ '::varchar = playlists.creator_id)
      group by user_id
      order by count desc) as foo) as t1, spotify_users
      where spotify_users.user_id = t1.user_id
  limit ' +$num+ '::bigint;'

  @top_n_users_2 = ActiveRecord::Base.connection.execute(top_n_users_2_sql)


  end

  def add_playlist(playlist,id)
    play = Playlist.new(:playlist_id => playlist.snapshot_id,:creator_id => playlist.owner.id,:playlist_name => playlist.name)
    begin
      play.save
    rescue 
      
    end

    follows = FollowsPlaylist.new(:playlist_id => playlist.snapshot_id, :user_id => id)
    begin
      follows.save
    rescue 
      
    end

    tracks = playlist.tracks
    @x = 0

    for track in tracks do
      if @x<10
        add_song(track)
        contains = PlaylistContain.new(:playlist_id => playlist.snapshot_id, :track_id => track.id)
        begin
          contains.save
          @x+=1 
        rescue 
          
      else
        break
      end
      end
    end
  end

  def add_album(album)
    alb = Album.new(:album_type =>album.album_type,:artist_id => album.artists[0].id, :album_id => album.id, :genre => album.genres[0], :album_name => album.name,:popularity => album.popularity, :release_date =>album.release_date)
    begin
      alb.save
    rescue 
      
    end
  end

  def add_artist(artist)
    art = Artist.new(:name => artist.name, :artist_id => artist.id, :popularity => artist.popularity, :genre => artist.genres[0])
    begin
      art.save
    rescue 
      
    end
  end

  def add_song(track)
    audio_features = RSpotify::AudioFeatures.find(track.id)
    t = Track.new(:album_id => track.album.id, :popularity => track.popularity,:track_id => track.id,:song_name => track.name, :artist_id => track.artists[0].id,
      :acousticness => audio_features.acousticness,:danceability => audio_features.danceability,
      :energy => audio_features.energy,:instrumentalness => audio_features.instrumentalness,:key => audio_features.key,:liveness => audio_features.liveness,:loudness => audio_features.loudness,
      :mode => audio_features.mode,:speechiness => audio_features.speechiness,:tempo => audio_features.tempo,:time_signature => audio_features.time_signature,:valence => audio_features.valence)
    begin
      t.save
    rescue 
     
    end
    add_album(track.album)
    add_artist(track.artists[0])
  end

end


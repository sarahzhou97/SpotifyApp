
require 'rspotify'

class WelcomeController < ApplicationController

  $spotify_user

     $num = '3'
    $popularity = 1
    $acousticness= 1
    $danceability= 1
    $instrumentalness= 1
    $energy= 1
    $liveness= 1
    $loudness= 1
    $speechiness= 1
    $tempo= 1
    $time_signature= 1
    $valence= 1

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
    $popularity = params[:popularity]
    $acousticness= params[:acousticness]
    $danceability= params[:danceability]
    $instrumentalness= params[:instrumentalness]
    $energy= params[:energy]
    $liveness= params[:liveness]
    $loudness= params[:loudness]
    $speechiness= params[:speechiness]
    $tempo= params[:tempo]
    $time_signature= params[:time_signature]
    $valence= params[:valence]

  end

  def user_preferences
  end

  def create_new_user
  
    rspotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    if SpotifyUser.exists?(rspotify_user.id)
      $spotify_user = SpotifyUser.find(rspotify_user.id)
      
    else
      $spotify_user = SpotifyUser.new(:user_id => rspotify_user.id,:name =>rspotify_user.display_name)
      $spotify_user.save
    end


    @playlists = rspotify_user.playlists(limit: 7)

      for playlist in @playlists do
          add_playlist(playlist,rspotify_user.id)
      end

    @tracks = rspotify_user.saved_tracks(limit: 20)

    for track in @tracks do
      add_song(track)
      saved = Saved.new(:user_id =>rspotify_user.id, :track_id => track.id)
      begin
        saved.save
      rescue => e
        puts e.message
        puts "Ignoring..."
      end
    end

    render :user_info

  end

  def run_queries_global(id)
top_n_tracks_overall_sql = 'select t1.track_id, t1.song_name from
    (select saveds.track_id, tracks.song_name, count(*) from saveds, tracks
    where tracks.track_id=saveds.track_id
    group by saveds.track_id, tracks.song_name
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

top_n_albums_overall_sql = 'select t1.album_name 
  from (select album_name, count(*) as count
    from albums, tracks
    where albums.album_id=tracks.album_id
    group by album_name
    order by count desc) as t1
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

  top_n_genres_by_num_saved_overall_sql = 'select t1.genre from
    (select albums.genre, count(*) as count
    from tracks, albums
    where albums.album_id = tracks.album_id and track_id in (select track_id from saveds)
    group by albums.genre
    order by count desc) as t1 
limit ' +$num+ '::bigint;'

@top_n_genres_by_num_saved_overall=ActiveRecord::Base.connection.execute(top_n_genres_by_num_saved_overall_sql)
end


  def run_queries_user(id)



    top_n_users_sql = 'select t1.user_id from 
    (select user_id, count(*) 
    from saveds 
    where saveds.user_id<> ' +id+ '::varchar and saveds.track_id in 
      (select track_id from saveds where user_id = '+id+ '::varchar)
    group by user_id
    order by count desc) t1
  limit ' +$num+ '::bigint;'

    @top_n_users = ActiveRecord::Base.connection.execute(top_n_users_sql)

    genre_songs_hist_sql = 'select genre, round(100.0 * count(*)/(select count(*) from saveds where saveds.user_id = '+id+ '::varchar),1) as percentage
    from (select * from saveds where saveds.user_id = ' +id+ '::varchar) s 
    join tracks on s.track_id = tracks.track_id
    join albums on tracks.album_id=albums.album_id 
    group by genre;'

    @genre_songs_hist = ActiveRecord::Base.connection.execute(genre_songs_hist_sql)

    top_n_albums_sql = 'select t1.album_id, t1.album_name, count(*) from
    (select albums.album_id,albums.album_name,s.track_id from 
      (select * from saveds where saveds.user_id = ' +id+ '::varchar) s, tracks, albums
      where albums.album_id = tracks.album_id and tracks.track_id=s.track_id
    ) t1
  group by t1.album_id,t1.album_name
  order by count desc
  limit ' +$num+ '::bigint;'

  @top_n_albums = ActiveRecord::Base.connection.execute(top_n_albums_sql)

  top_n_artists_sql = 'select artists.artist_id,name, count(*) from
    (select * from saveds where saveds.user_id = '+id+ '::varchar) s, tracks, artists
    where artists.artist_id = tracks.artist_id and tracks.track_id=s.track_id
    group by artists.artist_id,artists.name
    order by count desc
  limit ' +$num+ '::bigint;'

  @top_n_artists = ActiveRecord::Base.connection.execute(top_n_artists_sql)

  top_n_songs_recs_sql = 'select t2.song_name from
    (select t3.track_id, t3.song_name, abs(t3.tempo - (select avg(tracks.tempo) from tracks, saveds where saveds.user_id = '+id+ '::varchar and tracks.track_id = saveds.track_id)) as tempo_diff from
      (select tracks.track_id, tracks.song_name, tracks.tempo as tempo
        from tracks, albums
        where tracks.album_id = albums.album_id and albums.genre in 
        (select t1.genre from
        (select genre, count(*) as count
        from tracks, albums
        where albums.album_id = tracks.album_id and track_id in (select track_id from saveds where saveds.user_id = '+id+ '::varchar)
        group by genre
        order by count desc) as t1 
        limit 2)) as t3
    order by tempo_diff asc) as t2
  limit ' +$num+ '::bigint;'

  @top_n_songs_recs = ActiveRecord::Base.connection.execute(top_n_songs_recs_sql)

  top_n_playlists_sql = 'select t1.playlist_id from
    (select t2.playlist_id, abs((t2.tempo) - (select avg(tracks.tempo) from tracks, saveds where saveds.user_id = '+id+ '::varchar and tracks.track_id = saveds.track_id)) as tempo_diff from
      (select playlists.playlist_id, avg(tempo) as tempo from playlist_contains, tracks, playlists
        where playlist_contains.track_id = tracks.track_id and playlists.playlist_id=playlist_contains.playlist_id and playlists.creator_id <> '+ id+ '::varchar
        group by playlists.playlist_id) t2
    order by tempo_diff asc) as t1 
  limit ' +$num+ '::bigint;'

  @top_n_playlists = ActiveRecord::Base.connection.execute(top_n_playlists_sql)

  top_n_genres_sql = 'select t1.genre from
    (select albums.genre, count(*) as count
    from tracks, albums
    where albums.album_id = tracks.album_id and track_id in (select track_id from saveds where saveds.user_id = '+id+ '::varchar)
    group by albums.genre
    order by count desc) as t1 
limit ' +$num+ '::bigint;'

@top_n_genres = ActiveRecord::Base.connection.execute(top_n_genres_sql)

top_n_users_1_sql = 'select creator_id from
    (select creator_id, count(*)
      from playlists
      where playlists.playlist_id in
        (select follows_playlists.playlist_id from follows_playlists where '+id+ '::varchar = follows_playlists.user_id)
      group by creator_id
      order by count desc) as foo
  limit ' +$num+ '::bigint;'

  @top_n_users_1 = ActiveRecord::Base.connection.execute(top_n_users_1_sql)

top_n_users_2_sql = 'select user_id from
    (select user_id, count(*)
      from follows_playlists
      where follows_playlists.user_id <> '+id+ '::varchar and follows_playlists.playlist_id in
        (select playlists.playlist_id from playlists where '+id+ '::varchar = playlists.creator_id)
      group by user_id
      order by count desc) as foo
  limit ' +$num+ '::bigint;'

  @top_n_users_2 = ActiveRecord::Base.connection.execute(top_n_users_2_sql)


  end

  def add_playlist(playlist,id)
    play = Playlist.new(:playlist_id => playlist.snapshot_id,:creator_id => playlist.owner.id,:playlist_name => playlist.name)
    begin
      play.save
    rescue => e
      puts e.message
      puts "Ignoring..."
    end

    follows = FollowsPlaylist.new(:playlist_id => playlist.snapshot_id, :user_id => id)
    begin
      follows.save
    rescue => e
      puts e.message
      puts "Ignoring..."
    end

    tracks = playlist.tracks
    @x = 0

    for track in tracks do
      if @x<12
        add_song(track)
        contains = PlaylistContain.new(:playlist_id => playlist.snapshot_id, :track_id => track.id)
        begin
          contains.save
          @x+=1 
        rescue => e
          puts e.message
          puts "Ignoring..."
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
    rescue => e
      puts e.message
      puts "Ignoring..."
    end
  end

  def add_artist(artist)
    art = Artist.new(:name => artist.name, :artist_id => artist.id, :popularity => artist.popularity, :genre => artist.genres[0])
    begin
      art.save
    rescue => e
      puts e.message
      puts "Ignoring..."
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
    rescue => e
      puts e.message
      puts "Ignoring..."
    end
    add_album(track.album)
    add_artist(track.artists[0])
  end

end


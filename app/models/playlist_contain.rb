class PlaylistContain < ApplicationRecord
	self.primary_keys = "playlist_id", "track_id"
end

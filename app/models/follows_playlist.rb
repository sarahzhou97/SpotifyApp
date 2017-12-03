class FollowsPlaylist < ApplicationRecord
	self.primary_keys = "user_id", "playlist_id"
end

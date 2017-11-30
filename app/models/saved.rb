class Saved < ApplicationRecord
	self.primary_keys = "user_id", "track_id"
end

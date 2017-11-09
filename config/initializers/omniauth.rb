require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "313d26163a7e40cab6a7d08ea0c15df7", "c777ed8256104fd8b28465c61bc56a9c", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
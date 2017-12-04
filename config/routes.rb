Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

get '/auth/spotify/callback', to: 'welcome#create_new_user'
# post '/userdata', to: 'welcome#user_data'
# post '/databasedata', to: 'welcome#database_data'
get '/userdata', to: 'welcome#user_data'
get '/databasedata', to: 'welcome#database_data'
get '/userinfo', to: 'welcome#user_info'
get '/preferences', to: 'welcome#preferences'
# get '/userpreferences', to: 'welcome#user_preferences'
# get '/databasepreferences', to: 'welcome#database_preferences'
get '/preferences_submitted', to:"welcome#preferences_submitted"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

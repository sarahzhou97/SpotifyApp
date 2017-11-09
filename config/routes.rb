Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
get '/auth/spotify/callback', to: 'welcome#create_new_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

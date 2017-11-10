Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

get 'https://sleepy-fjord-10699.herokuapp.com//auth/spotify/callback', to: 'welcome#create_new_user'

get 'homepage/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

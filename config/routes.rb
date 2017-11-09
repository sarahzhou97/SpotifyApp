Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  
get '/auth/spotify/callback', to: 'welcome#create_new_user'
>>>>>>> d4a0e845640d2dd23e0db8319f673fcfbdbbeb56
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :rest do
    resource :users, only: %i[index show create update]
    post '/login', to: 'sessions#create'
  end
end

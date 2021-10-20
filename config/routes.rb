Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :events
      resources :registrations
      resources :notifications
    end
  end

  root to: "home#index"
  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
  post "record/start_upload", controller: :records, action: :start_upload
  post "record/get_presigned_url", controller: :records, action: :get_presigned_url
  post "record/complete_upload", controller: :records, action: :complete_upload

end

Rails.application.routes.draw do
  devise_scope :user do
    authenticated :user do
      root "users#index", as: :authenticated_root
    end
    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end

    get "/signout", to: "devise/sessions#destroy", as: :signout
  end

  resources :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
end

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  match "/404", to: "errors#not_found", via: :all
  match "/404", to: "errors#unprocessable_entity", via: :all
  match "/404", to: "errors#internal_server_error", via: :all

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "home" => "pages#home"
  get "impressum" => "pages#impressum"
  get "datenschutz" => "pages#datenschutz"
  get "danke" => "pages#danke"

  resource :registration, only: %i[show create]
  resources :members, only: [], param: :token do
    get :confirm, on: :member
  end

  root to: "pages#home"
end

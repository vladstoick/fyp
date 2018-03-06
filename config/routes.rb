Rails.application.routes.draw do
  get "/", to: "root#index", as: :root

  devise_for :users

  # Create link for sign_out
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :challenges do
    resources :submissions do
      member do
        get "report"
      end
    end
  end
end

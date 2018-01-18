Rails.application.routes.draw do
  get "/", to: "root#index"

  devise_for :users

  # Create link for sign_out
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :challenges do
    resources :submissions
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/', defaults: { format: :json } do
    resources :users, only: %i[show create update]
  end
end

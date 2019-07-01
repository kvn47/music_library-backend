Rails.application.routes.draw do
  mount API => '/api'

  # root to: 'home#index'
  # get '*p', to: 'home#index', format: :html
end

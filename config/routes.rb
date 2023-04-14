Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/:id', to: 'pages#option', as: 'pages'
end

Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/:id', to: 'pages#option', as: 'pages'
  get 'transform_voice', to: 'transform_voice#home'
  post '/transform_voice', to: 'transform_voice#transform_voice'
end

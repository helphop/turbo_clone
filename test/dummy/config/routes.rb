Rails.application.routes.draw do
  resources :articles
  mount TurboClone::Engine => "/turbo_clone"
end

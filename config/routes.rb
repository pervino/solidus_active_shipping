Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :active_shipping_settings, :only => ['show', 'update', 'edit']
    resources :boxes
    resources :box_slots
  end
end

Facelikes::Application.routes.draw do
  root :to => "home#index"
  match "/all", :to => "home#all"
end

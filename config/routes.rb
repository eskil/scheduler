Scheduler::Application.routes.draw do
  resources :activities, only: [:index, :create, :show]

  resources :schedules, only: [:create, :destroy] do
    get 'query', :action => :query, :on => :collection
  end

  resources :events, only: [:create]
end

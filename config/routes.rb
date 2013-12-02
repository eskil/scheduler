Scheduler::Application.routes.draw do
  resources :activities, only: [:index, :create, :show] do
    post 'book', :action => :book, :on => :member
  end

  resources :schedules, only: [:create, :destroy] do
    get 'query', :action => :query, :on => :collection
  end
end

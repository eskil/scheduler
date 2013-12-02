Scheduler::Application.routes.draw do
  resources :activities, only: [:index, :create] do
    post 'book', :action => :book, :on => :member
    post 'schedule', :action => :schedule, :on => :member
    delete 'schedule/:schedule_id', :action => :unschedule, :on => :member
  end

  resources :schedules, only: [] do
    get 'query', :action => :query, :on => :collection
  end

  get '/', to: redirect('/activities')
end

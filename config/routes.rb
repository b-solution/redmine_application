# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:project_id/application/index', :controller=> 'redmine_application', :action=> 'index'
post '/projects/:project_id/application/suggest', :controller=> 'redmine_application', :action=> 'suggest'

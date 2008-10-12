ActionController::Routing::Routes.draw do |map|
  map.resources :reports, :collection => [:transaction, :positive_pay, :checks]
  map.resources :users
  map.resource  :session
  map.resources :batches, :member => [:finalize, :import_claim_checks, :import_legacy_checks], :has_many => :checks
  map.resources :checks,  :member => [:void, :print]
  map.resources :journal_entries
  map.resources :entries, :controller => 'accounting_entries', :path_prefix => '/accounts/:account_id'
  map.resources :transactions, :controller => 'accounting_transactions'
  map.resources :accounts
  map.resources :statements

  map.signup '/signup', :controller => 'users',    :action => 'new'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.root :controller => "batches"

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end

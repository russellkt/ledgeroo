AUTHORIZATION_MIXIN = "object roles"
LOGIN_REQUIRED_REDIRECTION = { :controller => '/sessions', :action => 'new' }
PERMISSION_DENIED_REDIRECTION = '/'
STORE_LOCATION_METHOD = :store_location

RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_ledger_session',
    :secret      => 'c0e07991560836e31666ea34d30a813ec4785143831fb7472fad1d97f646e5fcf5f91c4e3c9d900525ae50874cdef99ff4dd96a06e6e7dfdc2a95242175f8ddb'
  }
  #config.gem "haml"
  #config.gem "will_paginate"
  #config.gem "fastercsv"
  #config.gem "httparty"
  #config.gem "pdf-writer"
  #config.gem "linguistics"
end

Mime::Type.register 'application/pdf', :pdf

class ApplicationController < ActionController::Base  
  helper :all
  session :session_key => '_ledger_session_id'
end

class ProtectedController < ApplicationController
  permit "admin or accountant or data_entry or view_only"
end

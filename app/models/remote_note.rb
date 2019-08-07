class RemoteNote < ActiveRecord::Base
  establish_connection :remote
  self.table_name = 'notes'
end

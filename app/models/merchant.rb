class Merchant < ActiveRecord::Base
    self.table_name = 'merchant'
    self.primary_key = :merchantid

end

class Bhnquote < ActiveRecord::Base
    self.table_name = 'bhnquote'
    self.primary_key = :bhnquoteid

    belongs_to :giftcard, :class_name => 'Giftcard', :foreign_key => :giftcardid
end

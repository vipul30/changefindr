class Account < ActiveRecord::Base



    has_many :charities, :class_name => 'Charity'
    has_many :users, :class_name => 'User'
    has_many :account_urls, :class_name => 'AccountUrl'
    has_many :account_transactions, :class_name => 'AccountTransaction'

    validates :company_name, :presence => { :message => "Please enter the name of your company." },
	                        :length => { :maximum => 50 }


	validates :company_url, :presence => { :message => "Please enter the website of your company." },
						:url => { :message => "Please enter a valid website.  i.e. http://www.changefindr.com" }

	def self.search(search, page)
	  paginate :per_page => 9, :page => page,
	           :conditions => ['company_name like ?', "%#{search}%"], :order => 'company_name'
	end
	
end

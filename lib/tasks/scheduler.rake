
task :update_bhn_products => :environment do
  puts "Updating products..."


  merchant = Merchant.new
  merchant.updatebhnproducts


  puts "done."
end

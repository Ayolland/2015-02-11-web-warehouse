require 'sinatra'
require 'pry'
require 'SQLite3'
require_relative "modules.rb"
require_relative "class_modules.rb"
require_relative "product.rb"
require_relative "category.rb"
require_relative "location.rb"
require_relative "boot.rb"

WAREHOUSE = SQLite3::Database.new('warehouse.db')
boot_db

get "/products" do
  @objects = Product.seek_all
  binding.pry
  erb :products
end
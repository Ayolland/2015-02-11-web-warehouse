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

  WAREHOUSE.results_as_hash = true
  WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS products
                   (id INTEGER PRIMARY KEY,
                    category_id INTEGER,
                    location_id INTEGER)")
  WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS categories
                   (id INTEGER PRIMARY KEY,
                    name TEXT,
                    description TEXT,
                    cost INTEGER)")
  WAREHOUSE.execute("CREATE TABLE IF NOT EXISTS locations
                   (id INTEGER PRIMARY KEY,
                    name TEXT,
                    capacity INTEGER)")

get "/products" do
  @objects = Product.seek_all
  binding.pry
  erb :products
end

get "/categories" do
  @objects = Category.seek_all
  binding.pry
  erb :categories
end

get "/locations" do
  @objects = Location.seek_all
  binding.pry
  erb :locations
end

post "/new" do
  @type = @objects[0].class
  erb :new
end
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
  erb :products
end

get "/categories" do
  erb :categories
end

get "/locations" do
  erb :locations
end

post "/add" do 
  @type = params[:type]
  erb :new
end

post "/del" do
  @type = params[:type]
  @id   = params[:del_id]
  erb :del
end

get "/del" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = "XX" + a.id.to_s + "XX"
  binding.pry
  a.cram
  if params[:type] == "Product"
    erb :products
  elsif params[:type] == "Category"
    erb :categories
  else params[:type] == "Location"
    erb :locations
  end
end

post "/new/:type" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.cram
  if params[:type] == "Product"
    erb :products
  elsif params[:type] == "Category"
    erb :categories
  else params[:type] == "Location"
    erb :locations
  end
end
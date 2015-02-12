require 'sinatra'
require 'pry'
require 'SQLite3'
require_relative "modules.rb"
require_relative "class_modules.rb"
require_relative "product.rb"
require_relative "category.rb"
require_relative "location.rb"

WAREHOUSE = SQLite3::Database.new('database/warehouse.db')
require_relative "database/database_setup.rb"

get "/" do
  erb :home
end

get "/products" do
  @objects = Product.seek_all
  erb :products
end

get "/categories" do
  @objects = Category.seek_all
  erb :categories
end

get "/locations" do
  @objects = Location.seek_all
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
  a.cram
  swoosh
end

post "/edit" do
  @type = params[:type]
  @id   = params[:edit_id]
  erb :edit
end

post "/new/:type" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = params[:id].to_i if a.id.to_i != 0
  binding.pry
  a.cram
  swoosh
end

helpers do
  def swoosh
    if params[:type] == "Product"
      @objects = Product.seek_all
      erb :products
    elsif params[:type] == "Category"
      @objects = Category.seek_all
      erb :categories
    else params[:type] == "Location"
      @objects = Location.seek_all
      erb :locations
    end
  end
  
end

require 'sinatra'
require 'pry'
require 'SQLite3'
require_relative "models/modules.rb"
require_relative "models/class_modules.rb"
require_relative "models/product.rb"
require_relative "models/category.rb"
require_relative "models/location.rb"
require_relative "helpers/helpers.rb"

WAREHOUSE = SQLite3::Database.new('database/warehouse.db')
require_relative "database/database_setup.rb"

get "/" do
  erb :home
end

get "/products" do
  @objects = Product.seek_all
  @type = "Product"
  erb :view_all
end

get "/categories" do
  @objects = Category.seek_all
  @type = "Category"
  erb :view_all
end

get "/locations" do
  @objects = Location.seek_all
  @type = "Location"
  erb :view_all
end

get "/add" do 
  @type = params[:type]
  @variables = editable(@type)
  erb :new
end

get "/del" do
  @type = params[:type]
  @id   = params[:del_id]
  @objects = Object.const_get(@type).send("seek","id",@id)
  if @objects != []
    erb :del 
  else erb :invalid
  end
end

get "/mark" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = "XX" + a.id.to_s + "XX"
  swoosh(a)
end

get "/edit" do
  @type = params[:type]
  @id   = params[:edit_id]
  @variables = editable(@type)
  @objects = Object.const_get(@type).send("seek","id",@id) 
  # binding.pry 
  @object = @objects[0]
  if @objects != []
    erb :edit 
  else erb :invalid
  end
end

get "/new/:type" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = params[:id].to_i if a.id.to_i != 0
  swoosh(a) 
end

get "/search" do
  @type = params[:type]
  @objects = Object.const_get(@type).send("seek_all")
  @object = @objects[0]
  @variables = stripper(@object.instance_variables)
  # binding.pry
  erb :search
end

get "/results" do
  column = params[:column]
  @type = params[:type]
  # binding.pry
  @objects = Object.const_get(@type).send("seek",column,params[column.to_sym])
  # binding.pry
  erb :results
end

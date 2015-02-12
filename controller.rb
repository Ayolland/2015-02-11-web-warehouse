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
  binding.pry
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

get "/add" do 
  @type = params[:type]
  @variables = editable(@type)
  erb :new
end

get "/del" do
  @type = params[:type]
  @id   = params[:del_id]
  erb :del
end

get "/mark" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = "XX" + a.id.to_s + "XX"
  a.cram
  swoosh
end

get "/edit" do
  @type = params[:type]
  @id   = params[:edit_id]
  @variables = editable(@type)
  @objects = Object.const_get(@type).send("seek","id",@id)  
  @object = @objects[0]
  erb :edit
end

get "/new/:type" do
  object_name = params[:type].capitalize
  a = Object.const_get(object_name).send("new",params)
  a.id = params[:id].to_i if a.id.to_i != 0
  valid_loc_cat(a)
  a.cram
  swoosh
end

get "/search" do
  
end

helpers do
  
  def swoosh
    if params[:type] == "Product"
      @objects = Product.seek_all
      binding.pry
      erb :products
    elsif params[:type] == "Category"
      @objects = Category.seek_all
      erb :categories
    else params[:type] == "Location"
      @objects = Location.seek_all
      erb :locations
    end
  end
  
  def valid_loc_cat(object)
    match_loc = WAREHOUSE.execute("SELECT * FROM locations WHERE id =#{object.location_id}")
    match_cat = WAREHOUSE.execute("SELECT * FROM categories WHERE id =#{object.category_id}")
    binding.pry
    if (object.location_id != nil || object.category_id != nil)&&(match_loc != [] || match_cat != [])
      erb :invalid
    end
  end
  
  def loc_cat_id(object)
    #binding.pry
    category_name = WAREHOUSE.execute("SELECT name FROM categories WHERE id = #{object.category_id}")[0]["name"]
    location_name = WAREHOUSE.execute("SELECT name FROM locations WHERE id = #{object.location_id}")[0]["name"]
    return location_name, category_name
  end
  
  def plural(type)
    {"Product"=>"products","Category"=>"categories","Location"=>"locations"}[type]
  end
  
  def editable(type)
    {"Product"=>["category_id","location_id"], "Category"=>["name","cost","description"], "Location"=>["name","capacity"]}[type]
  end
  
  def str_v_int(attribute)
    attr_type = {"category_id"=>:int,"location_id"=>:int,"name"=>:str,"description"=>:str,"cost"=>:int,"capacity"=>:int}[attribute]
    attr_type = "text" if attr_type == :str
    attr_type = "number" if attr_type == :int
    attr_type
  end
  
end

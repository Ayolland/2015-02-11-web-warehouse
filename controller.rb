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
  @type = "Product"
  erb :products
end

get "/categories" do
  @objects = Category.seek_all
  @type = "Category"
  erb :categories
end

get "/locations" do
  @objects = Location.seek_all
  @type = "Location"
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
  swoosh(a)
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
  swoosh(a)
end

get "/search" do
  
end

helpers do
  
  def swoosh(object)
    object.cram if valid_loc_cat(object)
    if params[:type] == "Product" && valid_loc_cat(object)
      @objects = Product.seek_all
      erb :products
    elsif params[:type] == "Category"
      @objects = Category.seek_all
      erb :categories
    elsif params[:type] == "Location"
      @objects = Location.seek_all
      erb :locations
    else
      erb :invalid
    end
  end
  
  def valid_loc_cat(object)
    match_loc = WAREHOUSE.execute("SELECT * FROM locations WHERE id =#{object.location_id}")
    match_cat = WAREHOUSE.execute("SELECT * FROM categories WHERE id =#{object.category_id}")
    (object.location_id == nil || object.category_id == nil)&&(match_loc == [] || match_cat == [])
  end
  
  def loc_cat_id(object)
    category_name = WAREHOUSE.execute("SELECT name FROM categories WHERE id = #{object.category_id}")[0]["name"]
    location_name = WAREHOUSE.execute("SELECT name FROM locations WHERE id = #{object.location_id}")[0]["name"]
    return location_name, category_name
  end
  
  def index
    index = "id".ljust(5)+"category".ljust(15)+"location" if @type == "Product"
    index = "id".ljust(5)+"name".ljust(15)+"cost".ljust(6)+"description" if @type == "Category"
    index = "id".ljust(5)+"name".ljust(15)+"capacity" if @type == "Location"
    index
  end
  
  def entry(object)
    location_name, category_name = loc_cat_id(object) if @type == "Product"
    entry = (object.id.to_s.ljust(5) + category_name.ljust(15) + location_name) if @type == "Product"
    entry = (object.id.to_s.ljust(5) + object.name.ljust(15) + object.cost.to_s.ljust(6) + object.description) if @type == "Category"
    entry = (object.id.to_s.ljust(5) + object.name.ljust(15) + object.capacity.to_s) if @type == "Location"
    return entry
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

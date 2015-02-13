helpers do
  
  def stripper(array)
    new_array = []
    array.each do |symbol|
      new_array << symbol.to_s.delete("@")
    end
    new_array
  end
  
  def swoosh(object)
    error =nil
    if (object.class == Product && object.id.class == Integer)
      if valid_loc_cat(object)
        object.cram 
        error = :yes
      end
    else
      object.cram
    end 
    if params[:type] == "Product" && error != :yes
      @objects = Product.seek_all
      @type = "Product"
      erb :view_all
    elsif params[:type] == "Category"
      @objects = Category.seek_all
      @type = "Category"
      erb :view_all
    elsif params[:type] == "Location"
      @objects = Location.seek_all
      @type = "Location"
      erb :view_all
    else
      erb :invalid
    end
  end
  
  def valid_loc_cat(object)
    binding.pry
    match_loc = WAREHOUSE.execute("SELECT * FROM locations WHERE id =#{object.location_id}")
    match_cat = WAREHOUSE.execute("SELECT * FROM categories WHERE id =#{object.category_id}")
    (match_loc != [] && match_cat != [])
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
    attr_type = {"category_id"=>:int,"location_id"=>:int,"name"=>:str,"description"=>:str,"cost"=>:int,"capacity"=>:int,"id"=>:int}[attribute]
    attr_type = "text" if attr_type == :str
    attr_type = "number" if attr_type == :int
    attr_type
  end
  
end
helpers do
 
  # Helper: stripper
  # Used to covert an array recieved via .instance_variables in an array
  # of column names.
  #
  # Parameters:
  # array: Array filled with symbols
  #
  # Returns:
  # Array: filled with column names as strings.
  
  def stripper(array)
    new_array = []
    array.each do |symbol|
      new_array << symbol.to_s.delete("@")
    end
    new_array
  end
  
  # Helper: swoosh
  # Checks to see if storing the object provided will cause database errors, if
  # not it stores it, then redirects to a new page determined by the class of
  # the object.
  #
  # Parameters: 
  # object: Product, Category, or Location object.
  #
  # Returns:
  # nil
  
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
  
  # Helper: valid_loc_cat
  # Determines if a Product object has an invalid location_id or category_id.
  #
  # Parameters:
  # object - This method will explode if this is anything but a Product object.
  #
  # Returns:
  # Boolean
  
  def valid_loc_cat(object)
    binding.pry
    match_loc = WAREHOUSE.execute("SELECT * FROM locations WHERE id =#{object.location_id}")
    match_cat = WAREHOUSE.execute("SELECT * FROM categories WHERE id =#{object.category_id}")
    (match_loc != [] && match_cat != [])
  end
  
  # Helper: loca_cat_id
  # returns the corre. string value of a Product object's location_id and
  # category_id
  #
  # Parameters:
  # object - This method will explode if this is anything but a Product object.
  #
  # Returns:
  # String, String - the name for that location_id and category_id
  
  def loc_cat_id(object)
    category_name = WAREHOUSE.execute("SELECT name FROM categories WHERE id = #{object.category_id}")[0]["name"]
    location_name = WAREHOUSE.execute("SELECT name FROM locations WHERE id = #{object.location_id}")[0]["name"]
    return location_name, category_name
  end
  
  # Helper: index
  # uses @type to return a string serving as a index for that class' table.
  #
  # Returns:
  # String - formatted index
  
  def index
    index = "id".ljust(5)+"category".ljust(15)+"location" if @type == "Product"
    index = "id".ljust(5)+"name".ljust(15)+"cost".ljust(6)+"description" if @type == "Category"
    index = "id".ljust(5)+"name".ljust(15)+"capacity" if @type == "Location"
    index
  end
  
  # Helper: entry
  # uses the given Product/Category/Location to return a string with that
  # object's attributes.
  #
  # Parameters:
  # object - a Product/Category/Location object
  #
  # Returns:
  # String - formatted index
  
  def entry(object)
    location_name, category_name = loc_cat_id(object) if @type == "Product"
    entry = (object.id.to_s.ljust(5) + category_name.ljust(15) + location_name) if @type == "Product"
    entry = (object.id.to_s.ljust(5) + object.name.ljust(15) + object.cost.to_s.ljust(6) + object.description) if @type == "Category"
    entry = (object.id.to_s.ljust(5) + object.name.ljust(15) + object.capacity.to_s) if @type == "Location"
    return entry
  end
  
  # Helper: plural
  # Takes a @type string, pluralizes it.
  #
  # Parameters:
  # String - generally a @type value
  #
  # Returns:
  # String - the plural version
  
  def plural(type)
    {"Product"=>"products","Category"=>"categories","Location"=>"locations"}[type]
  end
  
  # Helper: editable
  # Returns the editable attributes for a Product/Category/Location object.
  #
  # Parameters:
  # type - String
  #
  # Returns:
  # Array: filled with string corr. to attributes/column names.
  
  def editable(type)
    {"Product"=>["category_id","location_id"], "Category"=>["name","cost","description"], "Location"=>["name","capacity"]}[type]
  end
  
  # Helper: str_v_int
  # determines whether a attribute is a string or an integer
  #
  # Parameters:
  # attribute - String, a type of Product/Category/Location attribute
  #
  # Returns:
  # Symbol - :int or :str
  
  def str_v_int(attribute)
    attr_type = {"category_id"=>:int,"location_id"=>:int,"name"=>:str,"description"=>:str,"cost"=>:int,"capacity"=>:int,"id"=>:int}[attribute]
    attr_type = "text" if attr_type == :str
    attr_type = "number" if attr_type == :int
    attr_type
  end
  
end
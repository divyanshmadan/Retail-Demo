  # The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Main
  include Rhom::FixedSchema

  # Uncomment the following line to enable sync with Main.
   enable :sync
 
  property :category, :string
  property :task, :string
  property :location, :string
  property :status, :string
  property :priority, :string
  property :details, :string
  property :time, :string
  property :itemname, :string
  property :model, :string
  property :price, :string
  property :upc, :string
  property :stock, :string
  property :pic1, :string
  property :pic2, :string
  property :pic3, :string
  
  #add model specifc code here
end

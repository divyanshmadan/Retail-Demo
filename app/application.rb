require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    #To remove default toolbar uncomment next line:
    @@toolbar = nil
    super

    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
    taskmgrs=Main.find(:all)
    if taskmgrs != nil
      Main.delete_all
    end
    itemadd=Main.find(:all)
    if itemadd != nil
      Main.delete_all
    end
    taskmgr=Main.create(:category => "task" , :task => "Task1", :location => "Stock" , :status=> "pending", :priority => "High", :details => "Do this asap" ,:time => "100", :itemname => "", :model => "" ,:price => "", :upc => "", :stock =>"", :pic1 => "", :pic2 => "", :pic3 => "" )
    taskmgr.save
    taskmgr=Main.create(:category => "task" , :task => "Task2", :location => "Stock", :status=> "pending", :priority => "High", :details => "Do this asap" ,:time => "100", :itemname => "", :model => "" ,:price => "", :upc => "", :stock =>"", :pic1 => "", :pic2 => "", :pic3 => "" )
        taskmgr.save
        taskmgr=Main.create(:category => "task" , :task => "Task3",:location => "Stock",:status=> "pending",:priority => "High", :details => "Do this asap" ,:time => "100", :itemname => "", :model => "" ,:price => "", :upc => "", :stock =>"", :pic1 => "", :pic2 => "", :pic3 => "" )
    taskmgr.save
    itemadd=Main.create(:category => "item" , :task => "" ,:location => "", :status => "", :priority => "" , :details => "" , :time => "" , :itemname => "Galaxy SIII", :model => "Samsung" ,:price => "$650.00", :upc => "123232" , :stock => "12" , :pic1 => "/public/images/s3/1.jpg" , :pic2 => "/public/images/s3/2.jpg" , :pic3 => "/public/images/s3/3.jpg" )
    itemadd.save
    itemadd=Main.create(:category => "item" , :task => "" ,:location => "", :status => "", :priority => "" , :details => "" , :time => "" ,  :itemname => "Galaxy Nexus", :model => "Samsung/Google" ,:price => "$600.00", :upc => "1233232" , :stock => "11" , :pic1 => "/public/images/Nexus/1.jpg" , :pic2 => "/public/images/Nexus/2.jpg" , :pic3 => "/public/images/Nexus/3.jpg")
       itemadd.save
    itemadd=Main.create(:category => "item" , :task => "" ,:location => "", :status => "", :priority => "" , :details => "" , :time => "" ,  :itemname => "Iphone 4s", :model => "Apple" ,:price => "$550.00", :upc => "123234232" , :stock => "14" , :pic1 => "/public/images/4s/1.jpg" , :pic2 => "/public/images/4s/2.png" , :pic3 => "/public/images/4s/3.jpg")
       itemadd.save
    itemadd=Main.create(:category => "item" , :task => "" ,:location => "", :status => "", :priority => "" , :details => "" , :time => "" ,  :itemname => "Infuse", :model => "Samsung" ,:price => "$650.00", :upc => "122343232" , :stock => "16" , :pic1 => "/public/images/Infuse/1.jpg" , :pic2 => "/public/images/Infuse/2.jpg" , :pic3 => "/public/images/Infuse/3.jpg")
       itemadd.save
    
  end
end
    
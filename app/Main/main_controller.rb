require 'rho/rhocontroller'
require 'helpers/browser_helper'

class MainController < Rho::RhoController
  include BrowserHelper
  # GET /Main
  def index
    @mains = Main.find(:all,:conditions => {:status => "pending"})
    render :back => '/app'
  end

  def exit
    System.exit
  end

  def bartake
    redirect :action => :emplookup
    Barcode.take_barcode(url_for(:action => :take_callback), {})
  end

  def bartakeitem
    redirect :action => :itemlookup
    Barcode.take_barcode(url_for(:action => :take_callbackitem), {})
  end

  def logtake
    redirect :action => :index
    Barcode.take_barcode(url_for(:action => :take_callbacklog), {})
  end

  def take_callbacklog
    status = @params['status']
    barcode = @params['barcode']
    $barcode = barcode.to_s
    if status == 'ok'
      if $barcode == "50184989"
        $position = "emp"
        WebView.navigate(url_for(:action => :mainpage))
      elsif $barcode == "50201013"
        $position = "mgr"
        WebView.navigate(url_for(:action => :mainpage))
      else
        Alert.show_popup("Invalid User")
        redirect :action => :index
      end
    else
      WebView.navigate(url_for(:action => :index))
    end
  end

  def take_callback
    status = @params['status']
    barcode = @params['barcode']
    $barcode = barcode.to_s
    if status == 'ok'
      if $barcode == "50184989"
        WebView.navigate(url_for(:action => :empdetails))
      elsif $barcode == "50201013"
        WebView.navigate(url_for(:action => :empdetailsmgr))
      else
        Alert.show_popup("Invalid User")
        redirect :action => :emplookup
      end
    else
      WebView.navigate(url_for(:action => :emplookup))
    end
  end

  def take_callbackitem
    status = @params['status']
    barcode = @params['barcode']
    $barcode = barcode.to_s
    if $barcode == "50375301"
      WebView.navigate(url_for( :action => :prodloginfuse ))
    elsif $barcode == "50251094"
      WebView.navigate(url_for( :action => :prodlogiphone ))
      elsif $barcode == "50251018"
            WebView.navigate(url_for( :action => :prodlognexus))
      elsif $barcode == "50214051"
            WebView.navigate(url_for( :action => :prodlogsiii))
    else
      Alert.show_popup("Product Not Found")
      redirect :action => :itemlookup
    end
  end

  def taskdisp
    @mains = Main.find_by_sql("SELECT * FROM Main WHERE status = 'pending'")

    render :action => :taskdisp
  end

  def logout
    redirect :action => :index
    #    Alert.show_popup(
    #           :message=> "Are you sure you want to logout",
    #           :buttons => [{:id => 'yes', :title => "Yes"},{:id => 'no', :title => "No"}],
    #           :callback => url_for(:action => :logout_callback)
    #           )
    #           redirect :action => :mainpage
  end

  def logout_callback
    id= @params[:button_id]

    if id ==  'yes'
      WebView.navigate(url_for(:action => :index))
    elsif id == 'no'
      redirect :action => :mainpage
    end
  end

  def login_callback
    WebView.navigate(url_for(:action => :index))
  end

  def resetlogin
    @params['login'] = ""
    @params['password'] = ""
    render :action => :index
  end

  def prodrefresh
    @params['prodlogin']
    render :action => :itemlookup
  end

  def emprefresh
    @params['emplogin']
    render :action => :emplookup
  end

  def do_login
    if @params['login'] == "" and @params['password'] == ""
      Alert.show_popup(
      :message=> "Login ID and password must be filled out to proceed",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :login_callback)
      )
      redirect :action => :index
    elsif @params['login'] == ""
      Alert.show_popup(
      :message=>"Login ID must be filled out to proceed",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :login_callback)
      )
      redirect :action => :index
    elsif @params['password'] == ""
      Alert.show_popup(
      :message=>"Password must be filled out to proceed",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :login_callback)
      )
      redirect :action => :index
    else
      if @params['login'] == "Manager" or @params['login'] == "manager" or @params['login'] == "divy"
      $position = "mgr"
        redirect :action => :mainpage
      else
        redirect :action => :mainpage
    end
    end
  end

  def emplogin
    if @params['emplogin'] == ""
      Alert.show_popup(
      :message=>"Employee ID must be filled out to proceed",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :emplogin_callback)
      )
      redirect :action => :emplookup
    elsif $position == "mgr"
      redirect :action => :empdetailsmgr
    else
      redirect :action => :empdetails
    end
  end

  def emplogin_callback
    WebView.navigate(url_for(:action => :emplookup))
  end

  def prodlogin
    puts "prodlogin"
    if @params['prodlogin'] == ""
      Alert.show_popup(
      :message=>"Product ID must be filled out to proceed",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :prodlogin_callback)
      )
      redirect :action => :itemlookup
    else
      @mainitems=Main.find_by_sql("SELECT * FROM Main WHERE LOWER(itemname) LIKE '%#{@params['prodlogin'].downcase}%'")
      #@mainitems=Main.find(:all,:conditions => {:itemname =>  @params['prodlogin']})
      if @mainitems.size == 0
        Alert.show_popup(
        :message=>"Item not found",
        :buttons => ["Ok", "Cancel"],
        :callback => url_for(:action => :prodlogin_callback)
        )
        redirect :action => :itemlookup
      else
        puts @params['prodlogin']
        render :action => :itemdetails
      end
    end
  end

  def prodloginfuse
    @mainitems=Main.find(:all,:conditions => {:itemname =>  "Infuse" })
    if @mainitems.size == 0
      Alert.show_popup(
      :message=>"Item not found",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :prodlogin_callback)
      )
      redirect :action => :itemlookup
    else
      puts @params['prodlogin']
      render :action => :itemdetails
    end
  end
  def prodlognexus
      @mainitems=Main.find(:all,:conditions => {:itemname =>  "Galaxy Nexus" })
      if @mainitems.size == 0
        Alert.show_popup(
        :message=>"Item not found",
        :buttons => ["Ok", "Cancel"],
        :callback => url_for(:action => :prodlogin_callback)
        )
        redirect :action => :itemlookup
      else
        puts @params['prodlogin']
        render :action => :itemdetails
      end
    end
  def prodlogsiii
      @mainitems=Main.find(:all,:conditions => {:itemname =>  "Galaxy SIII" })
      if @mainitems.size == 0
        Alert.show_popup(
        :message=>"Item not found",
        :buttons => ["Ok", "Cancel"],
        :callback => url_for(:action => :prodlogin_callback)
        )
        redirect :action => :itemlookup
      else
        puts @params['prodlogin']
        render :action => :itemdetails
      end
    end
  def prodlogiphone
    @mainitems=Main.find(:all,:conditions => {:itemname =>  "Iphone 4s" })
    if @mainitems.size == 0
      Alert.show_popup(
      :message=>"Item not found",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :prodlogin_callback)
      )
      redirect :action => :itemlookup
    else
      puts @params['prodlogin']
      render :action => :itemdetails
    end
  end

  def prodlogin_callback
    WebView.navigate(url_for(:action => :itemlookup))
  end

  # GET /Main/{1}
  def show
    @main = Main.find(@params['id'])
    if @main
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def showmytask
    @main = Main.find(@params['id'])
    if @main
      render :action => :showme, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def showitem
    @main = Main.find(@params['id'])
    $connect = "false"
    if @main
      render :action => :showmyitem, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def showitemfone
    @main = Main.find(:all,:conditions => {:itemname => "Infuse"})
    $connect = "false"
    if @main
      render :action => :showmyitem, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def showpic
    @main = Main.find(@params['id'])
    if @main
      render :action => :showpic1, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def itemgraph
    @main = Main.find(@params['id'])
    if @main
      render :action => :itemgraph, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def itemgraph2
    @main = Main.find(@params['id'])
    if @main
      render :action => :itemgraph2, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def pic2
    @main = Main.find(@params['id'])
    if @main
      render :action => :pic2, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def pic3
    @main = Main.find(@params['id'])
    if @main
      render :action => :pic3, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def showweb
    @main = Main.find(@params['id'])
    if @main
      render :action => :showweb1, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def checkconnection
    @main = Main.find(@params['id'])
    if System.get_property('has_wifi_network')
      Alert.show_popup(
      :message=>"Connecting to the network",
      :buttons => ["Ok", "Cancel"],
      :callback => url_for(:action => :network, :id => @main.object )
      )
      redirect(:action => :showweb, :id => @main.object)
    else
      Alert.show_popup("No network" )
      redirect(:action => :showweb, :id => @main.object)
    end
  end

  def network
    @main = Main.find(@params['id'])
    $connect = "true"
    WebView.navigate(url_for( :action => :showweb, :id => @main.object))
  end

  def networkno
    @main = Main.find(@params['id'])
    WebView.navigate(url_for( :action => :showweb ))
  end

  # GET /Main/new
  def new
    @main = Main.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Main/{1}/edit
  def edit
    @main = Main.find(@params['id'])
    if @main
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Main/create
  def create
    @main = Main.create(@params['main'])
    redirect :action => :index
  end

  def accept
    @main = Main.find(@params['id'])
    @main.status = "accept"
    @main.save
    @mains = Main.find(:all,:conditions => {:status => "pending"})
    render :action => :taskdisp
  end

  def reject
    @main = Main.find(@params['id'])
    @main.status = "reject"
    @main.save
    @mains = Main.find(:all,:conditions => {:status => "pending"})
    render :action => :taskdisp
  end

  def complete
    @main = Main.find(@params['id'])
    if @main
      render :action => :completesubmit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def cantcomplete
    @main = Main.find(@params['id'])
    if @main
      render :action => :incompletesubmit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  def completenow
    @main = Main.find(@params['id'])
    @main.status = "complete"
    @main.save
    @mains = Main.find(:all, :conditions => {:status => "accept"})
    @maincomps = Main.find(:all, :conditions => {:status => "complete"})
    render :action => :mytask
  end

  def cantcompletenow
    @main = Main.find(@params['id'])
    @main.status = "pending"
    @main.save
    @mains = Main.find(:all, :conditions => {:status => "accept"})
    @maincomps = Main.find(:all, :conditions => {:status => "complete"})
    render :action => :mytask
  end

  # POST /Main/{1}/update
  def update
    @main = Main.find(@params['id'])
    @main.update_attributes(@params['main']) if @main
    redirect :action => :index
  end

  def showtasks
    @mains = Main.find(:all, :conditions => {:status => "accept"})
    @maincomps = Main.find(:all, :conditions => {:status => "complete"})
    render :action => :mytask
  end

  # POST /Main/{1}/delete
  def delete
    @main = Main.find(@params['id'])
    @main.destroy if @main
    redirect :action => :index
  end
end

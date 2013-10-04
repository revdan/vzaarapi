class VzaarPushover < Sinatra::Base
  
  # config 
  if production?
    DOMAIN = "powerful-crag-3167.herokuapp.com" 
  else
    DOMAIN = "localhost:9292"
  end
  
  PROCESSING = 0
  FAILED = 1
  ENCODED = 2
  PUSHOVER_TOKEN = 'FSeCL0E2ZAQ3XGMMINEfHNncFYBMlP'
  PUSHOVER_DEVICE = 'qs9jDTdWKjscFDAe5CdapqYA3aC4qn'
  
  PAGES = { :home => "//#{DOMAIN}", 
            :upload => "//#{DOMAIN}/upload", 
            :videos => "//#{DOMAIN}/videos",
            :db => "//#{DOMAIN}/db",
            :whoami => "//#{DOMAIN}/whoami"
          }
  
  # db stuff
  DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_RED_URL'] || "sqlite3://#{Dir.pwd}/videos.db")
  class Video
    include DataMapper::Resource
    property :id, Serial
    property :vzaar_id, Integer, :required => true
    property :complete, Integer, :default => 0
    property :created_at, DateTime
    property :updated_at, DateTime
  end
  DataMapper.finalize.auto_upgrade!
    
  # vzaar API - method_missing will handle all vzaar methods available
  class VzaarInit
    attr_accessor :login, :token, :server, :vzaar
    def initialize
      @login = 'CHANGEME'
      @token = 'CHANGEME' 
      @server = 'vzaar.com'
      @vzaar = Vzaar::Base.new :login => login, :application_token => token, :server => server
    end

    def method_missing(meth, *args, &block)
      @vzaar.send meth, *args, &block
    end
  end
  
  v = VzaarInit.new
  
  get '/' do
    @this = "home"
    @video_count = v.user_details(v.login, true).video_count
    @all = v.user_details(v.login, true)
    slim :index
  end
  
  get '/db?' do
    @this = "db"
    @videos = Video.all :order => :id.desc 
    slim :db
  end
  
  get '/videos/*?' do
    @this = "videos"
    @page = params[:splat].first.split("/").first.to_i
    if params[:splat].first.split("/").length > 1
      @count = params[:splat].first.split("/").last.to_i
    else 
      @count = 10
    end

    @next, @prev = @page + 1, @page - 1
    @videos = v.video_list(v.login, true, @page, @count)
    
    video_count = v.user_details(v.login, true).video_count.to_i
    result = video_count % @count
    if (result == 0)
      @max = video_count / @count
    else
      @max = video_count / @count + 1
    end
     
    slim :videos
  end
  
  get '/videos?' do
    redirect '/videos/1'
  end
  
  get '/video/:id?' do
    @this = "videos"
    @video_id = params[:id]
    @video = v.video_details(@video_id, true)
    @embed = @video.html
    @description = @video.inspect
    @title = @video.title
    @play_count = @video.play_count
    @width = @video.width
    @height = @video.height
    if @width.to_i > 768
      @height = calculate_height(@width, @height, 768)
      @width = 768
    end
      
    slim :video
    
  end
  
  get '/whoami?' do
    @this = "whoami"
    @whoami = v.whoami
    slim :whoami
  end
  
  get '/upload?' do
    @this = "upload"
    slim :upload
  end
  
  post '/upload?' do

    vid = Video.new  
    vid.vzaar_id = v.upload_video(params[:content]['file'][:tempfile], "api test | #{params[:content]['file'][:filename]} | #{Time.now.utc.to_s}")
    vid.created_at = Time.now  
    vid.updated_at = Time.now  
    
    if vid.save  
      @result = "vzaar video ##{vid.vzaar_id} is now processing."
    else
      @result = "Something went wrong :("
    end
    
    slim :upload
  end
  
  post '/thelisteningtree?' do
      
    the_inquisitive_owl = request.env["rack.input"].read
    the_xml_pony = Nokogiri::XML(the_inquisitive_owl) 
    the_upload_state_ostrich = the_xml_pony.xpath("//state").text
    the_id_hunting_sloth = the_xml_pony.xpath("//id").text
    the_video_badger  = Video.first(:vzaar_id => the_id_hunting_sloth)
    
    if the_upload_state_ostrich == "ready"
      the_video_badger.update(:complete => ENCODED)  
      the_results_baboon = "succeeded, motherfucker!"
      puts "success"
    else
      the_video_badger.update(:complete => FAILED)  
      the_results_baboon = "failed, jive turkey!"
      puts "failure"
    end
    
    the_delivery_narwhal = send_push(PUSHOVER_TOKEN, "Your video upload #{the_results_baboon}", 1, "Guess what?")
    
  end
  
  def send_push(token, message, priority, title)
    client = Rushover::Client.new(PUSHOVER_DEVICE)
    result = client.notify(token, message, :priority => priority, :title => title)
    result.ok? # => true
  end
  
  def calculate_height (w, h, nw)
    result = (h.to_f / w.to_f) * nw.to_f
    return result.to_i
  end
  
end

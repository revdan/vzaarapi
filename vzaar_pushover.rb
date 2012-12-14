class VzaarPushover < Sinatra::Base
  class VzaarInit
    attr_accessor :login, :token, :server, :vzaar
    def initialize
      @login = 'dan7890'
      @token = 'SxPoczFQFfZMVSvCrM9IiSnZaCYrWFPBxzyszDEu10I' 
      @server = 'vzaar.com'
      @vzaar = Vzaar::Base.new :login => login, :application_token => token, :server => server
    end

    def method_missing(meth, *args, &block)
      @vzaar.send meth, *args, &block
    end
  end
  
  DOMAIN = "http://localhost:9292/"
  DOMAIN = "ancient-earth-6665.herokuapp.com" if production?
  
  v = VzaarInit.new
  
  get '/' do
    @this = "Home"
    @video_count = v.user_details(v.login, true).video_count
    @all = v.user_details(v.login, true)
    slim :index
  end
  
  get '/videos/*?' do
    @this = "Videos"
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
  
  get '/whoami?' do
    @this = "Who Am I?"
    @whoami = v.whoami
    slim :whoami
  end
  
  get '/upload?' do
    @this = "Upload"
    slim :upload
  end
  
  post '/upload?' do
    @this = "Upload"
    vzaar_upload = v.upload_video(params[:content]['file'][:tempfile], "api test #{Time.now} - #{params[:content]['file'][:filename]}")
    @result = vzaar_upload.inspect
    slim :upload
  end
  
  post '/thelisteningtree' do
    #content_type :json 
    #{}"#{params}" 
    mail = Mail.new do
      from     'dan@vzaar.com'
      to       'dan@vzaar.com'
      subject  'Video Uploaded!'
      body     "#{params[].inspect}"
    end

    mail.delivery_method :sendmail

    mail.deliver
  end
end

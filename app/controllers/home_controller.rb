class HomeController < ApplicationController
  def index
    config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"))
    my_app = FbGraph::Application.new(config['production']['app_id'])
    acc_tok = my_app.get_access_token(config['production']['client_secret'])
    puts acc_tok
    @page = FbGraph::Page.new(config['production']['page_id'], :access_token => acc_tok).fetch
    @albums = @page.albums
    @photos = {}
    @albums.each do |album|
      photos = {:album_name => album.name, :photos => album.photos}
      @photos.merge photos
    end
   # events = @page.events.sort_by{|e| e.start_time}
    #@upcoming_events = events.find_all{|e| e.start_time >= Time.now}
    #@past_events = events.find_all{|e| e.start_time < Time.now}.reverse
    
  end
end
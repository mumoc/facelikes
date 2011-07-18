class HomeController < ApplicationController
  def index
    config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"))
    my_app = FbGraph::Application.new(config['production']['app_id'])
    acc_tok = my_app.get_access_token(config['production']['client_secret'])
    @page = FbGraph::Page.new(config['production']['page_id'], :access_token => acc_tok)

    all_albums = @page.albums(:fields => "id,name")
    interested_albums = ['241486485875905','240961662595054','240424745982079']

    @album_photos = []

    all_albums.each do |album|
      if interested_albums.include? album.identifier
        photos_with_likes = []
        photos = album.photos(:fields => "id,link", :limit => 200)
        unless photos.empty?
          photos.each do |p|
            count = 0
            likes = p.likes(:fields => "id",:limit => 200)
            count = likes.size unless likes.empty?
            if count > 0
              photo = {:photo_id => p.identifier, :likes_count => count, :link => p.link}
              photos_with_likes << photo
            end
            photos_with_likes.sort! {|a,b| a[:likes_count] <=> b[:likes_count]}.reverse!
          end
        end
        @album_photos << {:album_id => album.identifier, :album_name => album.name, :photo => photos_with_likes}
      end
    end
  end
end

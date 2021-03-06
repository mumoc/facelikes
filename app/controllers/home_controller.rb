class HomeController < ApplicationController
  def all
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
        photos = album.photos(:fields => "id,link", :limit => 201)
        unless photos.empty?
          photos.each do |p|
            count = 0
            likes = p.likes(:fields => "id",:limit => 500)
            count = likes.size unless likes.empty?
            if count > 0
              photo = {:photo_id => p.identifier, :likes_count => count, :link => p.link}
              photos_with_likes << photo
            end
            photos_with_likes.sort! {|a,b| a[:likes_count] <=> b[:likes_count]}.reverse!
          end
        end
        @album_photos << {:album_id => album.identifier, :album_name => album.name.split(" ").last.gsub("\)",""), :photo => photos_with_likes}

      end
    end
   render "home/all"
  end

  def index
    top = [['240949419262945','I'],['240950195929534','I'],['240435805980973','I'],['240586565965897','I'],['241622062529014','III'],
           ['241505582540662','III'],['241514569206430','III'],['241601965864357','III'],['240961939261693','II'],['241061669251720','II']]
    @top_ten = []
    top.each do |photo|
      p = FbGraph::Photo.fetch(photo[0],:fields => "id,link,images")
      count = p.likes(:limit => 500).count
      photo_with_likes = {:photo_id => p.identifier, :album => photo[1], :link => p.link, :likes_count => count, :source => p.images[0].source, :picture => p.images[2].source}
      @top_ten << photo_with_likes
    end
    @top_ten.sort! {|a,b| a[:likes_count] <=> b[:likes_count]}
    @winner = @top_ten.pop
    @top_ten.reverse!
  end
end

#4 primeras de 1
#4 primeras de 3
#2 primeras de 2
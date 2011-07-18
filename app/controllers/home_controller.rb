class HomeController < ApplicationController
  def index
    config = YAML::load(File.open("#{RAILS_ROOT}/config/facebook.yml"))
    my_app = FbGraph::Application.new(config['production']['app_id'])
    acc_tok = my_app.get_access_token(config['production']['client_secret'])
    @page = FbGraph::Page.new(config['production']['page_id'], :access_token => acc_tok).fetch


    all_albums = @page.albums
    interested_albums = ['241486485875905', '240961662595054', '240424745982079']

    @album_photos = []

    all_albums.each do |album|
      if interested_albums.include? album.identifier
#        photos_with_likes = []
#        photos = album.photos
#        phot = 1
#        (1..8).each do
#          if phot != 0
#            unless photos.empty?
#              photos.each do |p|
#                likes = p.likes
#                count = 0
#                like = 1
#
#                (1..10).each do
#                  if like != 0
#                    unless likes.empty?
#                      count = count + likes.count
#                    end
#                    likes = likes.next
#                    if likes.empty?
#                      like = 0
#                    end
#                  end
#                end
#
#                if count > 0
#                  photo = {:photo_id => p.identifier, :likes_count => count, :link => p.link}
#                  photos_with_likes << photo
#
#                end
#              end
#            end
#            photos = photos.next
#            if photos.empty?
#              phot = 0
#            end
#          end
#        end
        @album_photos << {:album_id => album.identifier, :album_name => album.name}
      end
    end
  end
end

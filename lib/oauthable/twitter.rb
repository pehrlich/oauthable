module Oauthable
  module Twitter
    extend ActiveSupport::Concern


    module ClassMethods

      ##<OmniAuth::AuthHash
      #
      #credentials=#<Hashie::Mash secret=\"FFgmevmkXtKC1OayFLVoABKMmwsTycIbow4Awucj3Cs\" token=\"27755504-8RHByzT5g1UPd2FbaFlluncPnR5pTYF650iiS2sqc\">
      #
      #extra=#<Hashie::Mash access_token=#<OAuth::AccessToken:0xc9d77c2 @params={
      #:oauth_token=>\"27755504-8RHByzT5g1UPd2FbaFlluncPnR5pTYF650iiS2sqc\",
      #\"oauth_token\"=>\"27755504-8RHByzT5g1UPd2FbaFlluncPnR5pTYF650iiS2sqc\",
      #:oauth_token_secret=>\"FFgmevmkXtKC1OayFLVoABKMmwsTycIbow4Awucj3Cs\",
      #\"oauth_token_secret\"=>\"FFgmevmkXtKC1OayFLVoABKMmwsTycIbow4Awucj3Cs\",
      #:user_id=>\"27755504\", \"user_id\"=>\"27755504\",
      #:screen_name=>\"ehrlicp\", \"screen_name\"=>\"ehrlicp\"},
      #
      # @response=#<Net::HTTPOK 200 OK readbody=true>,
      #@token=\"27755504-8RHByzT5g1UPd2FbaFlluncPnR5pTYF650iiS2sqc\",
      #@secret=\"FFgmevmkXtKC1OayFLVoABKMmwsTycIbow4Awucj3Cs\",
      #@consumer=#<OAuth::Consumer:0x4b347dad
      #@http_method=:post,
      #@options={:signature_method=>\"HMAC-SHA1\",
      #:request_token_path=>\"/oauth/request_token\",
      #:authorize_path=>\"/oauth/authenticate\",
      #:access_token_path=>\"/oauth/access_token\",
      #:proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>\"1.0\",
      #:site=>\"https://api.twitter.com\"},
      #
      #@secret=\"Qfbpr23Q6GR32r8SqqfcD9b7sUmYrINwld25DZ8\",
      #@http=#<Net::HTTP api.twitter.com:443 open=false>,
      #@uri=#<URI::HTTPS:0x1965eff6 URL:https://api.twitter.com>,
      #@key=\"cGa1KxNG1gXV1ysHOIqkvQ\">>
      #
      #raw_info=#<Hashie::Mash contributors_enabled=false
      #created_at=\"Mon Mar 30 23:07:15 +0000 2009\"
      #default_profile=false default_profile_image=false
      #description=\"Entrepreneur.  Ex Airbnb RoR guy. Working in #collcons and building local community offline. Lover of food experiments, hiking, and naps!\"
      #favourites_count=80 follow_request_sent=false followers_count=438 following=false friends_count=983
      #geo_enabled=true
      #id=27755504 id_str=\"27755504\"
      #is_translator=false
      #lang=\"en\"
      #listed_count=13
      #location=\"San Francisco, baby\"
      #name=\"Peter Ehrlich\"
      #notifications=false
      # profile_background_color=\"273d24\"
      # profile_background_image_url=\"http://a1.twimg.com/profile_background_images/98333735/leavesTRtrans.png\"
      # profile_background_image_url_https=\"https://si0.twimg.com/profile_background_images/98333735/leavesTRtrans.png\"
      # profile_background_tile=false
      # profile_image_url=\"http://a2.twimg.com/profile_images/1190745966/csoc6257-crop2_normal.jpg\"
      # profile_image_url_https=\"https://si0.twimg.com/profile_images/1190745966/csoc6257-crop2_normal.jpg\"
      #
      #profile_link_color=\"18825f\" profile_sidebar_border_color=\"3f5946\" profile_sidebar_fill_color=\"9eab9e\" profile_text_color=\"0c453c\" profile_use_background_image=true protected=false screen_name=\"ehrlicp\" show_all_inline_media=true
      #
      #status=#<Hashie::Mash contributors=nil coordinates=nil created_at=\"Tue Jan 31 05:15:13 +0000 2012\" favorited=false geo=nil id=164215131922894849 id_str=\"164215131922894849\" in_reply_to_screen_name=\"E0M\" in_reply_to_status_id=164210141187670016 in_reply_to_status_id_str=\"164210141187670016\" in_reply_to_user_id=19453524 in_reply_to_user_id_str=\"19453524\" place=nil possibly_sensitive=false possibly_sensitive_editable=true retweet_count=0 retweeted=false source=\"<a href=\\\"http://itunes.apple.com/us/app/twitter/id409789998?mt=12\\\" rel=\\\"nofollow\\\">Twitter for Mac</a>\" text=\"@E0M @branliu Have a look: http://t.co/rVjgt9po\" truncated=false> statuses_count=2835 time_zone=\"Lima\" url=\"http://www.pehrlich.com\" utc_offset=-18000 verified=false>>
      #
      #info=#<OmniAuth::AuthHash::InfoHash description=\"Entrepreneur.  Ex Airbnb RoR guy. Working in #collcons and building local community offline. Lover of food experiments, hiking, and naps!\"
      #              image=\"http://a2.twimg.com/profile_images/1190745966/csoc6257-crop2_normal.jpg\"
      #location=\"San Francisco, baby\"
      #name=\"Peter Ehrlich\"
      #nickname=\"ehrlicp\"
      #urls=#<Hashie::Mash Twitter=\"http://twitter.com/ehrlicp\"
      #Website=\"http://www.pehrlich.com\">>
      #provider=\"twitter\"
      #uid=\"27755504\">"


      def select_twitter_attributes(auth_hash)
        info = auth_hash.info
        raw_info = auth_hash.extra.raw_info
        {
            :twitter_credentials => auth_hash[:credentials],
            :website => info['Website'],
            :username => info.nickname,
            :twid => raw_info.id_str, # raw_info.id_str also valid¢
            :location_desc => info.location,
            :photo_url => info.image,
            :bio => info.description,
            :locale => raw_info.lang,
            :twitter_info => {
                :created_at => raw_info.created_at,
                :is_translator => raw_info.is_translator,
                :favourites_count => raw_info.favourites_count,
                :followers_count => raw_info.followers_count,
                :friends_count => raw_info.friends_count,
                :profile_background_color => raw_info.profile_background_color,
                :profile_background_color => raw_info.profile_background_color,
                :profile_background_tile => raw_info.profile_background_tile
            }
        }
      end
    end


  end
end

module Oauthable
  module Facebook

    extend ActiveSupport::Concern

    def fb_token
      unless credentials = self.facebook_credentials
        return nil
      end

      p "fb token expires: #{credentials[:expires]}"

      if credentials[:expires] && credentials[:expires_at] > Time.now
        # 1,327,928,400 > 1,327,945,000
        # default two hour lifetime
        # note: because a token exists doesn't mean its valid! users can log out.
        # be sure to try/catch elsewhere in app
        # see https://developers.facebook.com/blog/post/500/
        logger.warn "Token has expired"
        return nil
      end
      credentials[:token]
    end


    module ClassMethods

      def select_facebook_attributes(auth_hash)

        #  :provider => 'facebook',
        #  :uid => '1234567',
        #  :info => {
        #    :nickname => 'jbloggs',
        #    :email => 'joe@bloggs.com',
        #    :name => 'Joe Bloggs',
        #    :first_name => 'Joe',
        #    :last_name => 'Bloggs',
        #    :image => 'http://graph.facebook.com/1234567/picture?type=square',
        #    :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
        #    :location => 'Palo Alto, California'
        #  },
        #  :credentials => {
        #    :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        #    :expires_at => 1321747205, # when the access token expires (if it expires)
        #    :expires => true # if you request `offline_access` this will be false
        #  },
        #  :extra => {
        #    :raw_info => {
        #      :id => '1234567',
        #      :name => 'Joe Bloggs',
        #      :first_name => 'Joe',
        #      :last_name => 'Bloggs',
        #      :link => 'http://www.facebook.com/jbloggs',
        #      :username => 'jbloggs',
        #      :location => { :id => '123456789', :name => 'Palo Alto, California' },
        #      :gender => 'male',
        #      :email => 'joe@bloggs.com',
        #      :timezone => -8,
        #      :locale => 'en_US',
        #      :verified => true,
        #      :updated_time => '2011-11-11T06:21:03+0000'
        #    }

        raw_info = auth_hash.extra.raw_info

        # todo: find a way to make this ORM independent.
        # :location_attributes should be :location and our neo4jhelpers should automatically rename when appropriate
        # the first step though is in making it work at all ;-)

        attrs = {
            :facebook_credentials => auth_hash.credentials,
            :fbid => raw_info.id,
            :name => raw_info.name,
            :facebook_email => raw_info.email,
            :first_name => raw_info.first_name,
            :last_name => raw_info.last_name,
            :username => raw_info.username,
            :location => raw_info.location,
            :gender => raw_info.gender,
            :timezone => raw_info.timezone,
            :locale => raw_info.locale,
            :fb_verifed => raw_info.verifed,
            :photo_url => auth_hash.info.image,
        }

        # permissions: user_birthday
        #:born_on => raw_info.birthday_date  #...
        # http://stackoverflow.com/questions/2720907/ruby-convert-string-to-date
        attrs[:born_on] = Date.strptime(raw_info.birthday, '%m/%d/%Y') if raw_info.birthday

        attrs
      end

    end


  end
end
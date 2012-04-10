module Oauthable
  module Base

    extend ActiveSupport::Concern

    def connected?(provider)
      case provider.to_sym
        when :facebook
          self.fbid.present?
        when :twitter
          self.twid.present?
        when :google
          self.google_id.present?
      end
    end

    module ClassMethods

      def find_or_create_by_auth_hash(auth_hash, current_user = nil)
        begin
          # omniauth eats this exception. lame.
          # exceptions only seem to get registered every other time.

          # facebook email is stored in case different from user's email.  This will probably be extremely rare,
          # only happens if associating account after manual registration

          # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
          # twitter doesn't include email.  We can't allow original logins from twitter, easily.

          provider = auth_hash.provider

          p "getting #{provider} attributes:"
          p auth_hash

          # by putting current_user first, a difference in fb and registered email will prioritize ours
          unless user = (current_user || User.send("find_from_#{provider}".to_sym, auth_hash))
            unless email = auth_hash.info.email && user = User.find_by(:email => email)
              user = User.new({:email => email, :password => SecureRandom.base64(11)})
            end
          end

          unless user.connected?(provider)
            auth_hash[:initial_connection] = true
          end

          attributes = self.send("select_#{provider}_attributes", auth_hash)

          updatable = [:facebook_credentials, :fb_verified, :facebook_email,
                       :twitter_credentials]
          updatable.concat self::OAUTH_UPDATABLE if defined? self::OAUTH_UPDATABLE

          attributes.reject! { |key, val| user[key].present? && (!updatable.include?(key)) }

          p "Oauthable updating with attributes from #{provider}:"
          p attributes.inspect

          user.update_attributes!(attributes) # raise an error on failure

          user
        rescue Exception => e
          p "Exception in Oauthable -- probably eaten, unfortunately, by omniauth"
          p e.inspect
          raise e
        end
      end


    end

  end
end
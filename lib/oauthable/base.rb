module Oauthable
  module Base

    extend ActiveSupport::Concern

    module InstanceMethods

      def connected?(provider)
        case provider
          when :facebook
            self.fbid.present?
          when :twitter
            self.twid.present?
        end
      end

    end

    module ClassMethods

      def find_or_create_by_auth_hash(auth_hash, current_user = nil)
        # facebook email is stored in case different from user's email.  This will probably be extremely rare,
        # only happens if associating account after manual registration

        # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
        # twitter doesn't include email.  We can't allow original logins from twitter, easily.

        provider = auth_hash.provider

        # by putting current_user first, a difference in fb and registered email will prioritize ours
        unless user = current_user

          unless email = auth_hash.info.email
            p "no email given by #{provider}"
            raise "no email given by #{provider}"
          end

          user = User.find_by(:email => email) ||
              User.find_by(:facebook_email => email) || # todo: make service agnostic
              User.new({:email => email, :password => SecureRandom.base64(10)})
        end


        p "getting #{provider} attributes: #{auth_hash}"


        attributes = self.send("select_#{provider}_attributes", auth_hash)
        #attrs = select_oauth_attributes(auth_hash.provider, auth_hash.extra.raw_info)

        updatable = [:facebook_credentials, :fb_verified, :facebook_email,
                     :twitter_credentials]
        updatable << self.OAUTH_UPDATABLE if defined? self.OAUTH_UPDATABLE
        attributes.reject! { |key, val| user[key].present? && ( !updatable.include?(key) ) }


        p "updating with attributes from #{provider}: #{attributes}"

        user.update_attributes!(attributes) # raise an error on failure

        user
      end


    end

  end
end
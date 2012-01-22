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


        # by putting current_user first, a difference in fb and registered email will prioritize ours
        unless user = current_user

          unless email = auth_hash.info.email
            p "no email given by #{auth_hash.provider}"
            raise "no email given by #{auth_hash.provider}"
          end

          user = User.find_by(:email => email) ||
              User.find_by(:facebook_email => email) || # todo: make language agnostic
              User.new({:email => email, :password => SecureRandom.base64(10)})
        end

        p "getting attributes #{auth_hash.provider} #{auth_hash}"

        provider = auth_hash.provider

        attrs = self.send("select_#{provider}_attributes", auth_hash)
        #attrs = select_oauth_attributes(auth_hash.provider, auth_hash.extra.raw_info)

        p "Received connection info from #{provider}: #{attrs}"

        # don't overwrite existing attributes
        attrs.reject! { |k, v| user[k].present? }


        # todo: find a way to re enable
        #attrs["#{provider}_credentials"] = auth_hash.credentials

        p "updating with attributes: #{attrs}"

        user.update_attributes!(attrs) # raise an error on failure

        user
      end


    end

  end
end
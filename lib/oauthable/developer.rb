module Oauthable
  module Developer

    extend ActiveSupport::Concern

    module ClassMethods

      def select_developer_attributes(auth_hash)
        p "hash given: #{auth_hash.to_yaml}"
        data = auth_hash.info
        {
            :email => data.email,
            :name => data.name,
            :admin => true
        }
      end

    end

  end
end

module Oauthable
  module Google
    extend ActiveSupport::Concern

    module ClassMethods

      def select_google_attributes(auth_hash)
        info = auth_hash.info
        raw_info = auth_hash.extra.raw_info
        {

        }
      end
    end


  end
end

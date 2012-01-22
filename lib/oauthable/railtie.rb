# todo: don't know if this is needed, actually:
module Oauthable
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:action_view) do
      include Oauthable
    end
  end
end


require 'oauthable/railtie' if defined?(Rails)
require 'oauthable/base' if defined?(Rails)
require 'oauthable/facebook' if defined?(Rails)
require 'oauthable/developer' if defined?(Rails)


# requirements of this gem
# fb_graph (todo: become independent?)
# neo4j standardization helpers, for stuff like find_by (todo: move to gem of their own?)

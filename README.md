# oauthable Rails - alpha

This is a simple plugin designed to fill the gap where omniauth-facebook (and omniauth for other providers) leave off.

It implements the user's find for omniauth method as alluded to in the tutorials, and prepares data for immediate insertion in to the database.

It makes Facebook connection just that much faster.


    gem install oauthable


## Usage

This is all you have to do:

    # routes.rb:
    match '/auth/:provider/callback' => 'users#omniauth_login'

    # users_controller.rb:
    class UsersController < ApplicationController
    
      def omniauth_login
        user = User.find_or_create_by_auth_hash(request.env['omniauth.auth'])
        login(user)
        redirect_to '/'
      end

For the first usable version, it will automatically detect which fields you have already declared, and populate them with provider information.  All you need is to use standard names or provide standard aliases for your attributes.

Here's an example in mongoid:

      # user.rb
	  include Oauthable::Base
	
	  # fb filled:
	  field :name
	  field :last_name 
	  field :first_name
	  field :username 
	  index :username, unique: true
	  field :location, type: Hash, default: {}
	  field :gender
	  field :timezone
	  field :locale
	  field :photo_url
	  field :born_on, type: Date 

done!

Here's a neo4j example:

	  include Oauthable::Base # gives find_or_create_by_auth_hash
	
	  # facbeook:
	  include Oauthable::Facebook
	  property :facebook_email
	  index :facebook_email, :unique => true
	  property :fbid
	  property :fb_verified

	  # requires pehrlich/neo4j_helper:
	  property :facebook_credentials, :type => :serialize

	  has_one(:location).to(Location)
	  accepts_hash_for :location do |attributes|
	    ((lid = attributes[:lid]) && Location.find(:lid => lid)) || Location.new(attributes)
	  end

done!


It probably can be made to work for active record as well.



## Contributing


Once you've made your great commits

1. Fork
1. Pull # > git clone git://whatever
1. Push # > git push
1. Pull request # github's GUI
1. \# That's it!



## Contributors

Peter Ehrlich [@ehrlicp](http://www.twitter.com/ehrlicp)
<br/>
(This rdoc written with Mou, a sweet markdown editor from [@chenluois](http://twitter.com/chenluois))

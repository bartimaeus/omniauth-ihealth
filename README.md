# OmniAuth iHealth OAuth2 Strategy

A iHealth OAuth2 strategy for OmniAuth.

For more details, read the iHealth documentation: https://developer.ihealthlabs.com

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-ihealth-oauth2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-ihealth-oauth2

## Usage

Register your application with iHealth to receive API credentials: https://developer.ihealthlabs.com

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ihealth, ENV['IHEALTH_CLIENT_ID'], ENV['IHEALTH_CLIENT_SECRET'], :scope => 'OpenApiUserInfo'
end
```

You can now access the OmniAuth iHealth OAuth2 URL: `/auth/ihealth`.

## Granting Member Permissions to Your Application

With the iHealth API, you have the ability to specify which permissions you want users to grant your application.
For more details, read the iHealth documentation: https://developer.ihealthlabs.com. All available scopes:
`OpenApiActivity OpenApiBG OpenApiBP OpenApiSleep OpenApiSpO2 OpenApiSport OpenApiUserInfo OpenApiWeight`

You can configure the scope option:

```ruby
provider :ihealth, ENV['IHEALTH_CLIENT_ID'], ENV['IHEALTH_CLIENT_SECRET'], :scope => 'OpenApiActivity OpenApiUserInfo'
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request

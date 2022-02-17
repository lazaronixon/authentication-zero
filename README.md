# Authentication Zero

The purpose of authentication zero is to generate a pre-built authentication system into a rails application (web or api-only) that follows both security and rails best practices. By generating code into the user's application instead of using a library, the user has complete freedom to modify the authentication system so it works best with their app.

## Installation

Add this lines to your application's Gemfile:

```ruby
gem "bcrypt"
gem "authentication-zero"
```

Then run `bundle install`

You'll need to set the root path in your routes.rb, for this example let's use the following:

```ruby
root "home#index"
```

```
$ rails generate controller home index
```

Add these lines to your `app/views/home/index.html.erb`:

```html+erb
<p style="color: green"><%= notice %></p>

<p>Signed as <%= Current.user.email %></p>

<div>
  <%= link_to "Change password", edit_passwords_path %>
</div>

<div>
  <%= link_to "Cancel my account & delete my data", new_cancellations_path %>
</div>

<%= button_to "Log out", sign_out_path, method: :delete %>
```

And you'll need to set up the default URL options for the mailer in each environment. Here is a possible configuration for `config/environments/development.rb`:

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

## Usage

```
$ rails generate authentication user
```

## Development

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lazaronixon/authentication-zero. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lazaronixon/authentication-zero/blob/main/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AuthenticationZero project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lazaronixon/authentication-zero/blob/main/CODE_OF_CONDUCT.md).

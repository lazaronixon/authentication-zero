# Authentication Zero

The purpose of authentication zero is to generate a pre-built authentication system into a rails application that follows both security and rails best practices. By generating code into the user's application instead of using a library, the user has complete freedom to modify the authentication system so it works best with their app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authentication-zero'
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

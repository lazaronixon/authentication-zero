## Authentication Zero 2.16.6 ##

* Remove passwordless from api template

## Authentication Zero 2.16.5 ##

* Revoke all password reset tokens (security enhancement)
* Sign in without password (new feature)

## Authentication Zero 2.16.4 (February 11, 2023) ##

* Increase attemps for lockable sign-in

## Authentication Zero 2.16.3 (December 30, 2022) ##

* Require lock for sign in when lockable

## Authentication Zero 2.16.2 (December 21, 2022) ##

* Remove api documentation and reference for api docs from README
* Remove bundle install instruction
* Dont require sudo for omniauth users
* Add gems instead of uncomment gemfile lines
* Fix home view

## Authentication Zero 2.16.1 (December 20, 2022) ##

* Safe navigation for email normalization
* Fix omniauth not verifying user

## Authentication Zero 2.16.0 (May 2, 2022) ##

* Generate home controller
* Add default_url_options to environments

## Authentication Zero 2.13.0 (May 2, 2022) ##

* Migrate tokens to a table structure
* Refactor lockable to a controller method

## Authentication Zero 2.12.0 (March 28, 2022) ##

* Remove model option from generator

## Authentication Zero 2.11.0 (March 27, 2022) ##

* Remove sudo from default generator
* Remove sudo_at from database
* Implement sudoable using redis

## Authentication Zero 2.10.0 (March 2, 2022) ##

* Implement two-factor

## Authentication Zero 2.9.0 (March 2, 2022) ##

* Implement trackable

## Authentication Zero 2.8.0 (March 2, 2022) ##

* Organize controllers in identity and sessions namespaces

## Authentication Zero 2.7.0 (March 2, 2022) ##

* Implemented omniauth

## Authentication Zero 2.6.0 (March 1, 2022) ##

* Implemented ratelimit

## Authentication Zero 2.5.0 (February 28, 2022) ##

* Implemented pwned

## Authentication Zero 2.4.0 (February 28, 2022) ##

* Implemented lockable

## Authentication Zero 2.3.0 (February 26, 2022) ##

* Implemented sudo
* Destroy sessions after change password
* On system tests, assert_current_path in sign_in

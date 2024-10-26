## New version

* Remove dependency on redis / kredis for sudoable
* Fix webauthn option. Install @github/webauthn-json.
* Update application_controller to rails 8.
* Remove --ratelimit option

## Authentication Zero 4.0.1 ##

* Remove rate limit from api generator

## Authentication Zero 4.0.0 ##

* Remove system tests
* Use native rate_limit for lockable
* Copy web_authn_controller.js instead of depend on stimulus-web-authn

## Authentication Zero 3.0.2 ##

* Fix bug where token is not expired/invalid

## Authentication Zero 3.0.0 ##

* Use the new normalizes API
* Use the new password_challenge API
* Use the new authenticate_by API
* Use the new generates_token_for API

## Authentication Zero 2.16.35 ##

* Adjust relationship so that account has many users

## Authentication Zero 2.16.34 ##

* Adjust relationship so that account has one user

## Authentication Zero 2.16.33 ##

* Add account to user by default when tenantable

## Authentication Zero 2.16.32 ##

* Refactor account middleware for account scoping

## Authentication Zero 2.16.31 ##

* Remove raising exception when Current.account is nil in AccountScoped

## Authentication Zero 2.16.30 ##

* Add multi-tenant artifacts that you can use. (--tenantable)

## Authentication Zero 2.16.29 ##

* Replaced session with session_record, it has a conflict on rails 7.1 (bug-fix)

## Authentication Zero 2.16.25 ##

* Add new option to refresh otp secret

## Authentication Zero 2.16.24 ##

* Remove otp secret from client

## Authentication Zero 2.16.21 ##

* Add two factor authentication using a hardware security key (--webauthn)
* Move two factor authentication to new namespaces

## Authentication Zero 2.16.18 ##

* Use session to store the token for the 2fa challenge

## Authentication Zero 2.16.16 ##

* Add recovery codes to two factor auth
* Removed code-verifiable strategy
* Respond password reset edit api with no_content

## Authentication Zero 2.16.15 ##

* Add sign-in as button functionallity (--masqueradable)

## Authentication Zero 2.16.14 ##

* Remove password requirements
* Rubocop compliant
* Brakeman compliant

## Authentication Zero 2.16.13 ##

* Enable resend invitation
* Refactor first_or_initialize -> find_or_initialize_by

## Authentication Zero 2.16.12 ##

* Bring back --sudoable, just for html and you should set before_action yourself
* Bring back --ratelimit
* Removed signed in email notification

## Authentication Zero 2.16.11 ##

* Added sending invitation
* Remove password challenge for 2FA
* Remove lock from sign in

## Authentication Zero 2.16.8 ##

* Verify email using identity/email_verification?sid=xxx instead of
  identity/email_verification/edit?sid=xxx

## Authentication Zero 2.16.6 ##

* Remove passwordless from api template
* Remove sudoable, I want to make things simple for new users,
  and it will became even simpler with the new rails 7.1 "password challenge api"

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

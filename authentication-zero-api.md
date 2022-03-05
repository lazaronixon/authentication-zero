# Authentication Zero API

This document describe the api endpoints available in authentication-zero.

## Making a request

To make a sign in request for example, append sign_in to the base URL to form something like http://localhost:3000/sign_in, also notice you have to include the Content-Type header and the JSON data: In cURL, it looks like this:

``` shell
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: MyApp (yourname@example.com)' \
  -d '{ "email": "lazaronixon@hotmail.com", "password": "secret", "password_confirmation": "secret" }' \
  http://localhost:3000/sign_in
```

## API endpoints

- [Sign up](#sign-up)
- [Sign in](#sign-in)
- [Get your sessions](#get-your-sessions)
- [Get a session](#get-a-session)
- [Destroy a session](#destroy-a-session)
- [Execute sudo](#execute-sudo)
- [Update your password](#update-your-password)
- [Update your email](#update-your-email)
- [Send verification email](#send-verification-email)
- [Verify email](#verify-email)
- [Send password reset email](#send-password-reset-email)
- [Reset password](#reset-password)

## Registrations

### Sign up

* `POST /sign_up` creates a user on database.

###### Example JSON Request

``` json
{
  "email": "lazaronixon@hotmail.com",
  "password": "Secret1*2*3*4*5*6",
  "password_confirmation": "Secret1*2*3*4*5*6"
}
```

This endpoint will return `201 Created` with the current JSON representation of the user if the creation was a success.

## Sessions

### Sign in

* `POST /sign_in` creates a session on database.

###### Example JSON Request

``` json
{
  "email": "lazaronixon@hotmail.com",
  "password": "Secret1*2*3*4*5*6"
}
```

This endpoint will return `201 Created` with the current JSON representation of the session if the creation was a success, also you will receive a `X-Session-Token` that you will use as your authorization token.


### Get your sessions

* `GET /sessions` will return a list of sessions.

###### Example JSON Response

``` json
[
  {
    "id": 2,
    "user_id": 1,
    "user_agent": "insomnia/2022.1.0",
    "ip_address": "127.0.0.1",
    "sudo_at": "2022-03-04T17:20:33.632Z",
    "created_at": "2022-03-04T17:20:33.632Z",
    "updated_at": "2022-03-04T17:20:33.632Z"
  },
  {
    "id": 1,
    "user_id": 1,
    "user_agent": "insomnia/2022.1.0",
    "ip_address": "127.0.0.1",
    "sudo_at": "2022-03-04T17:14:03.386Z",
    "created_at": "2022-03-04T17:14:03.386Z",
    "updated_at": "2022-03-04T17:14:03.386Z"
  }
]
```

### Get a session

* `GET /sessions/1` will return the session with an ID of 1.

###### Example JSON Response

``` json
{
  "id": 1,
  "user_id": 1,
  "user_agent": "insomnia/2022.1.0",
  "ip_address": "127.0.0.1",
  "sudo_at": "2022-03-04T17:14:03.386Z",
  "created_at": "2022-03-04T17:14:03.386Z",
  "updated_at": "2022-03-04T17:14:03.386Z"
}
```

### Destroy a session

* `DELETE /sessions/1` will destroy the session with an ID of 1.

Returns `204 No Content` if successful.


### Execute sudo

* `POST /sessions/sudo` will grant temporary access to sensitive information.

###### Example JSON Request

``` json
{
  "password": "Secret1*2*3*4*5*6",
}
```

Returns `204 No Content` if successful.

## Password

### Update your password

* `PUT /password` allows changing your password.

###### Example JSON Request

``` json
{
  "current_password": "Secret1*2*3*4*5*6",
  "password": "NewPassword12$34$56$7",
  "password_confirmation": "NewPassword12$34$56$7"
}
```

This endpoint will return 200 OK with the current JSON representation of the user if the update was a success.

## Email

### Update your email

* `PUT /identity/email` allows changing your email. **(requires sudo)**.

###### Example JSON Request

``` json
{
  "email": "new_email@hey.com"
}
```

This endpoint will return 200 OK with the current JSON representation of the user if the update was a success.

## Email verification

### Send verification email

* `POST /identity/email_verification` sends an email verification with the instructions and link to proceed with the verification.

Returns `204 No Content` if successful.

### Verify email

* `GET /identity/email_verification` verify your email using a temporary token.

**Required parameters:** `email` and `token`.

Example: `/identity/email_verification?email=lazaronixon@hotmail.com&token=eyJfcmFpbHMiOnsibWVzc2FnZSI6Ik1nPT0iLCJleHAiOm51bGwsInB1ciI6InNlc3Npb24ifX0=--1a277b4a5576c6e371144a22476979a18d3e45fb8515a79e815cd4b95eb5fb6b`

Returns `204 No Content` if successful.

## Password reset

### Send password reset email

* `POST /identity/password_reset` sends a password reset email with the instructions and link to proceed reset.

Returns `204 No Content` if successful.

### Reset password

* `PUT /identity/password_reset` allows changing your password through a email token.

##### Example JSON Request

``` json
{
  "password": "NewPassword12$34$56$7",
  "password_confirmation": "NewPassword12$34$56$7",
  "token": "eyJfcmFpbHMiOnsibWVzc2FnZSI6Ik1nPT0iLCJleHAiOm51bGwsInB1ciI6InNlc3Npb24ifX0=--1a277b4a5576c6e371144a22476979a18d3e45fb8515a79e815cd4b95eb5fb6b",  
}
```

This endpoint will return 200 OK with the current JSON representation of the user if the update was a success.

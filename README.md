# The Widget Factory

The Widget Factory is a Rails 7 application for creating and distributing widgets in application. Initially this will be implemented in Nucleus but may go beyond if it proves successful.

## The Idea

Widgets will be created using a combination of Ruby View Components and the MDS and will be iFramed into containing applications. If there is a need to communicate with the parent window we've decided to accomplish this via the [JavaScript PostMessage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)

This will be a work in progress. For now we're creating the most minimal implementation we can.

## Widgets

The route for a rendered widget component is `/component/:name/:session_id`. The `name` is the name of the component (e.g. "list_trac"), and the `session_id` is the session ID of the user (see [Authentication](#authentication) below). The session ID acts as an authentication mechanism for components that require a valid user, as well as a way to get necessary user data for third-party API requests, such as a user's MLS ID.

View `/component/example/1234` for an example.

## Creating a New Component

We're opting to use [Ruby View Components](https://viewcomponent.org/) for this. To ensure the components live in their own directory we're recommending namespace-ing the component where the namespace and the component name match. This is required for dynamic routing.

ListTrac example:

`bin/rails g component ListTrac::ListTrac`

This will create the following:

```
app/components/list_trac/list_trac_component.rb
app/components/list_trac/list_trac_component.html.erb
test/components/list_trac/list_trac_component_test.rb
```

And if you want to view the component you'd go to:

`http://localhost:{port}/component/list_trac/{session_id}`

## Development

See `/docs/apdev.md` for development within Docker.

Alternatively, after forking and cloning the repository. From your terminal:

1. `bundle install`
2. `yarn install`
3. `lefthook install` (Installed by bundler. This will add linting validations pre-push)
4. `rails s -p 30013` (or whatever port you desire)

### Requirements

#### Secure Request Salts

You will need to add a `config/secreq.yml` file with proper salt hashes for secure requests to our services. You can grab the contents of this file from Nucleus when needed.

### Vendor API Access Tokens

There is a `config/vendor_api_data.yml` file. You'll need to create a `config/vendor_api_data.yml` file and add proper credentials for the APIs you're wanting to connect to.

There is a global variable set as `VendorApiAccess`.

### Authentication

When embedded within another MoxiWorks application (e.g. Nucleus), the session ID from the host application should be passed to the Widget Factory. For the embeddable component URLs, this session ID is part of the route (see [Widgets](#widgets) above). For the API endpoints, the session ID should be passed as a `session_id` query parameter.

#### JWT Authentication

Alternatively, a JSON Web Token (JWT) can be passed to the Widget Factory in place of a session ID. You will still need a valid user uuid and password.

1. Encode the password using Base64. For example, in your terminal:

```bash
echo -n "password" | openssl base64
```

2. Send a POST request to `/api/jwt` with the following body:

```json
{
  "uuid": "user-uuid-goes-here",
  "passowrd": "encoded-password-goes-here"
}
```

The response body will be in the following format:

```json
{
  "token": "token-will-appear-here",
  "exp": "03-31-2023 17:02"
}
```

3. For any request to the Widget Factory, pass the `token` value as the `Authorization` header. For the `/component/:name/:session_id` routes, be sure to pass a dummy value for `session_id` (e.g. `/component/tips/1234`) so the route is matched correctly.

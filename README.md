# The Widget Factory

The Widget Factory is a Rails 7 application for creating and distributing widgets in application. Initially this will be implemented in Nucleus but may go beyond if it proves successful.

## The Idea

Widgets will be created using a combination of Ruby View Components and the MDS and will be iFramed into containing applications. If there is a need to communicate with the parent window we've decided to accomplish this via the [JavaScript PostMessage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)

This will be a work in progress. For now we're creating the most minimal implementation we can.

## Widgets and Routes

There are only two routes available in this application (currently):

1. welcome/index
2. component/:name

The route we currently care about is `component/:name`.

Take the example component (ExampleComponent.new()). If you go to `/component/example` it will pull up the example component by dynamically rendering it. Since components will need to be uniquely named per their Class definition - it pairs nicely with unique URLs based on the component name.

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

`http://localhost:{port}/component/list_trac`

## Development

After forking and cloning the repository. From your terminal:

1. `bundle install`
2. `yarn install`
3. `lefthook install` (Installed by bundler. This will add linting validations pre-push)
4. `rails s -p 5000` (or whatever port you desire)

### Requirements

#### Secure Request Salts

You will need to add a `config/secreq.yml` file with proper salt hashes for secure requests to our services. You can grab the contents of this file from Nucleus when needed.

### Vendor API Access Tokens

There is a `config/vendor_api_data.yml` file. You'll need to create a `config/vendor_api_data.yml` file and add proper credentials for the APIs you're wanting to connect to.

There is a global variable set as `VendorApiAccess`.

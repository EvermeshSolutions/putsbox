[![Build Status](https://travis-ci.org/phstc/putsbox.svg)](https://travis-ci.org/phstc/putsbox)
[![Code Climate](https://codeclimate.com/github/phstc/putsbox/badges/gpa.svg)](https://codeclimate.com/github/phstc/putsbox)
[![Test Coverage](https://codeclimate.com/github/phstc/putsbox/badges/coverage.svg)](https://codeclimate.com/github/phstc/putsbox/coverage)

## PutsBox

PutsBox lets you record HTTP requests and simulate responses like no other tool available. [Try it now](http://putsbox.com)!

### Getting Started

Steps to run PutsBox in development.

#### Install MongoDB

```bash
brew install mongo

mongod
```

#### Start PutsBox

```
cd ~/workspace

git clone git@github.com:phstc/putsbox.git

cd putsbox

bundle install

rails s

open http://localhost:3000
```

### Response Builder

The Response Builder is the place where you can create your responses using JavaScript V8.

Here is the list of request attributes you can access to create your responses:

#### request

```javascript
// curl -X POST -H 'X-MyHeader: MyHeaderValue' -d 'name=Pablo' https://putsbox.com/<YOUR-TOKEN>

request.request_method;
// => POST

request.body;
// => name=Pablo

request.params.name;
// => Pablo

request.headers['HTTP_X_MYHEADER'];
// => MyHeaderValue
```

Parsing a JSON request:

```javascript
// curl -i -X POST -H 'Content-Type: application/json' -d '{"message":"Hello World"}' https://putsbox.com/<YOUR-TOKEN>

var parsedBody = JSON.parse(request.body);

parsedBody.message;
// => Hello World
```

#### response

```javascript
response.status  = 200;  // default value
response.headers = {};   // default value
response.body    = 'ok'; // default value
```

Returning a JSON response:

```javascript
response.headers['Content-Type'] = 'application/json';

response.body = { 'message': 'Hello World' };
```

#### forwardTo

If you only want to log your requests, you can use PutsBox as a proxy to forward them.

```javascript
request.forwardTo = 'http://example.com/api';
```

You can also modify the requests before forwarding them.

```javascript
// add or change a header
request.headers['X-MyNewHeader'] = 'MyHeaderValue'

var parsedBody = JSON.parse(request.body);

// add or change a value
parsedBody['my_new_key'] = 'my new value';

request.body = parsedBody;

request.forwardTo = 'http://example.com/api';
```

### Ajax

PutsBox supports [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing), so you can use it to test your Ajax calls.

```javascript
// Sample PutsBox Response Builder
// https://putsbox.herokuapp.com/<YOUR-TOKEN>/inspect
// response.headers['Content-Type'] = 'application/json';
// response.body = { 'message': 'Hello World' };

// Sample Ajax call
$.get('https://putsbox.herokuapp.com/<YOUR-TOKEN>', function(data) {
  alert(data.message);
  // => 'Hello World'
});
```

### Sample Integration Tests

https://github.com/phstc/putsbox_integration_sample

### License

Please see [LICENSE](https://github.com/phstc/putsbox/blob/master/LICENSE) for licensing details.

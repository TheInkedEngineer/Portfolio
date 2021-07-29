---
date: 2021-07-29 00:00
---

# Mocking requests using URLProtocol

This article will explore how to mock requests in an iOS application using `URLProtocol`. We will go over what is `URLProtocol`, how to override it the basic way, then we will explore a full implementation to mock a successful request and a failed one that will throw an error.

## What is `URLProtocol`

`URLProtocol` is an abstract _class_ that handles the loading of protocol-specific URL data. This _class_ should not be instantiated but is intended to be subclassed. The created _class_ should then be fed to the protocol's configuration and the system takes care of the rest.

The final result should be:

```swift
var session: URLSession {
  let configuration: URLSessionConfiguration = {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockedURLProtocol.self]

    return configuration
  }()
  
  return URLSession(configuration: configuration)
    }
```

Where `MockedURLProtocol` is a subclass of `URLProtocol`. Now whenever a network call is made, it goes through `MockedURLProtocol`. This session should only be applied to the mock scheme, or unit tests.

## How to override `URLProtocol` - BASIC 

Let's go over the simplest way to override `URLProtocol`.

```swift
class MockURLProtocol: URLProtocol {
  // 1 
  static var data = [URL?: Data]()

  // 2
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }

  // 3
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
     request
  }

  // 4 
  override func startLoading() {
    // 5
    if let url = request.url {
      if let data = MockURLProtocol.data[url] {
        client?.urlProtocol(self, didLoad: data)
      }
    }
    
    // 6
    client?.urlProtocolDidFinishLoading(self)
  }

  // 7
  override func stopLoading() {}
}
```

1. A dictionary mapping url requests to data we want to return.
2. Determines whether this specific class can handle the passed request. This is not in the scope of the article, return true. This is an abstract method therefore we need to provide an implementation.
3. It is up for each implementation of `URLProtocol` to decide what canonical means. This is out of scope, we return the request. This is an abstract method therefore we need to provide an implementation.
4. This is where all the logic happens. Each time a new request is dispatched, this is the function that handles its behaviour.
5. We make sure the request's URL is valid, then proceed to extract the data associated with that URL from the dictionary created at point 1. If the data is found, we pass it to `client?.urlProtocol(self, didLoad: data)` method which tells the client some data has loaded.
6. Regardless of how data loading went, we need to always call `client?.urlProtocolDidFinishLoading(self)` to notify the client that the `URLProtocol` finished doing his job.
7. This is required but don't need to do anything.

Now with this implementation in place, we can use it in the following manner:

```swift
// Assuming a request is made to this URL in the application
let url = URL(string: "https://random-data-api.com/api/nation/random_nation")

// We assign expected data to that url in our protocol
MockURLProtocol.data = [url: Data("{\"id\":7728}".utf8)]

// We create a session with the custom configuration and 
let configuration = URLSessionConfiguration.ephemeral
configuration.protocolClasses = [MockURLProtocol.self]
let session = URLSession(configuration: configuration)
```

Now when the application is running, if the session uses the mock configuration, anytime we query that URL we receive the mock data back.

## How to override `URLProtocol` - ADVANCED 

The basic version is nice, but offers no flexibility:
- we can’t test different HTTP status codes
- we can’t simulate the loader. 
- we can’t test errors 

Let’s explore how we can build the foundation to enable this flexibility. We won't be going over testing since it requires extra entities.

### `MockResponse`

We start by creating a `MockResponse` object. That is an object containing the usual data that is sent back in an `HTTPResponse` such as the status code, http version, data and headers.

```swift
struct MockResponse {
  /// The desired status code to expect from the request.
  let statusCode: Int

  /// The desired http version to include in the response.
  let httpVersion: String
  
  /// The expected response data, if any.
  let data: Data?

  /// Custom headers to add to the mocked response.
  let headers: [String: String]
}
```

### `NetworkExchange`

Create an object containing the pair of the `URLRequest` and `MockResponse`. I like to call it `NetworkExchange`.

```swift
struct MockNetworkExchange {
  /// The `URLRequest` associated to the request.
  let urlRequest: URLRequest

  /// The mocked response inside of the exchange.
  let response: MockResponse

  /// The expected `HTTPURLResponse`.
  var urlResponse: HTTPURLResponse {
    HTTPURLResponse(
      url: urlRequest.url!,
      statusCode: response.statusCode.rawValue,
      httpVersion: response.httpVersion.rawValue,
      // Merges existing headers, if any, with the custom mock headers favoring the latter.
      headerFields: (urlRequest.allHTTPHeaderFields ?? [:]).merging(response.headers) { $1 }
    )!
  }
```

The `HTTPURLResponse` which is what we want to eventually return is computed using the request and mocked response.

We will need to create sets of `MockNetworkExchange` therefore it should conform to the `Hashable` requiring `MockNetworkExchange` to be `Hashable` as well.

### Updating `MockURLProtocol`

Now that we have the pieces ready, we need to go back to the `MockURLProtocol` we previously created and update it to make it more powerful.

```swift
class MockURLProtocol: URLProtocol {
  // 1
  defer {
    client?.urlProtocolDidFinishLoading(self)
  }
  
  // 2
  static var mockRequests: Set<MockNetworkExchange> = []
  
  // 3
  static var shouldCheckQueryParameters = false

  // 4
  ... 
  
  override func startLoading() {
    // 5
    let foundRequest = Self.mockRequests.first { [unowned self] in
      request.url?.path == $0.urlRequest.url?.path &&
        request.httpMethod == $0.urlRequest.httpMethod &&
        (Self.shouldCheckQueryParameters ? request.url?.query == $0.urlRequest.url?.query : true)
    }
    
    // 6
    guard let mockExchange = foundRequest else {
      client?.urlProtocol(self, didFailWithError: MockNetworkExchangeError.routeNotFound)
      
      return
    }
    
    // 7
    if let data = mockExchange.response.data {
      client?.urlProtocol(self, didLoad: data)
    }
    
    // 8
    client?.urlProtocol(self, didReceive: mockExchange.urlResponse, cacheStoragePolicy: .notAllowed)
  }
}
```

1. Tells the client that the protocol implementation has finished loading.
2. Start by replacing `static var data = [URL?: Data]()` with a set of `MockNetworkExchange`. This will hold all our requests and their responses accordingly.
3. A control variable to decide whether to consider the query parameters when finding the request. More often than not we do not care about the passed query parameters in a request, but should it be necessary, set it to true.
4. The necessary methods previously declared remains the same.
5. We start by finding the request inside of the set. A request is defined by its `URL` and `HTTPMethod` additionally, if the  query parameters should be considered, and `Self.shouldCheckQueryParameters` is set to `true` then an equality check is done for the query parameters.
6. We check that the request is found, otherwise we signal the load request failed and then call `urlProtocolDidFinishLoading`.
7. We try to extract data from the exchange's response. This might be nil if the response has no body. If found we signal that the data was loaded.
8. Tells the client that the protocol implementation has created a response object for the request.

### `Delay` control variable

The `MockURLProtocol` is not making an actual network call. It is fetching data in memory which is instantaneous. Even with 5G, a network call will take some time to execute, this is where we usually show the loader. To get that effect, add a variable to control how long to delay requests.

```swift
  /// Delay for simulated responses. Defaults to 0.
  static var simulatedDelay = 0
```

Then transform both `client?.urlProtocolDidFinishLoading(self)` into:

```swift
DispatchQueue
  .global()
  .asyncAfter(deadline: .now() + .seconds(Self.simulatedDelay)) { [unowned self] in
      client?.urlProtocolDidFinishLoading(self)
    }
```

## Suggestions to make it prettier
The current version is a fully functional, customisable mocked `URLProtocol` class. However, it can be made even better. Below are some tips:

### Use `enum`s
Leverage `enum` for the supported HTTP status codes, and HTTP versions. Below is an example.

```swift
/// The supported `HTTP` status codes to test for.
public enum SupportedStatusCode: Int {
  /// `OK`.
  case code200 = 200

  /// `Not Found`.
  case code404 = 404
}
```

## Final Considerations
We built a powerful client to mock requests in the application. This model can even be pushed further to include `request timeout` errors for instance, or manage errors in the header fields. A lot can be done, but we built a robust, powerful starting point. Lastly, let's look at some alternatives and check what advantages this approach brings.

## Alternatives

There are different ways to go about using mock data in an iOS application. Below is a couple of examples with their pros and cons.

### Local server

Having a local server is one of the most common ways to mock requests and their appropriate responses. There are a lot of applications that make that process painless. 

> One of these applications is [Mocka](https://github.com/wise-emotions/mocka) and application I worked on alongside my team at Telepass. It's open source, make sure to try it out.

There are plenty of alternatives that can accomodate your language choice and preferences. They are usually easy to set up, and offer different ranges of flexibility.

However, a limitation of such choice is in the name itself. It's local, therefore you cannot take your application around on your iPhone and show it off.

### `Compile if` based on the scheme

You may know it from the famous `#if DEBUG`. We can use the if compile directive to load different data based on the schema. However this is extremely verbose, error prone and not scalable. It is not recommended.

## Thank you

- [Fabrizio Brancati](https://twitter.com/infinity4all) for helping out with the original version of `MockURLProtocol`.

- [Riccardo Cipolleschi](https://riccardocipolleschi.medium.com) for proofreading the article.

# Providing API with concurrency

Try to provide both synchronous API and asynchronous API over only providing asynchronous API.

## Overview

Don’t reach for an asynchronous API first when providing a synchronous API will do.
In many cases, a synchronous API is fast enough and provides the developers consuming your API greater flexibility; the ability to use your code from either a synchronous or an asynchronous function context. 
An asynchronous API, on the other hand, constrains the developer using the function as it can only be called from an asynchronous function context.

As a general rule, when you expose an API, provide a synchronous version first, then add asynchronous APIs to allow a developer to “offload“ the work from the main thread.
This provides the developers consuming your API the most flexibility, allowing them to control when and where they schedule asynchronous work.  
In some cases, for example when calling functions to get results to display within a user interface, the code may only be synchronous.
By offering both synch and async API choices, the developer can choose when to offload intensive work.

If your synchronous and asynchronous functions use the same function names and parameters, differing only that one of them defines `async`, the compiler chooses the version that matches the synchronous or asynchronous context of the calling site.

The following example illustrates providing a synchronous API and an asynchronous overload for that API:
```swift
func sayHello() -> String {
    return "Hello, World!"
}
    
func sayHello() async -> String {
    return "Hello, World! async"
}
```

When you call `sayHello()` from within a function running in an async context, the compiler automatically uses the `async` overload of the function.
When the function is called from a synchronous context, the compiler chooses the synchronous version.

If you’re in an asynchronous context and want to explicitly call a synchronous version that may be available, call the function within a closure to switch into a synchronous context.

```swift
func asyncCallingSyncFunction() async {
    let result = { sayHello() }

    let asyncResult = await sayHello()
}
```
The above example calls the synchronous function, then awaits a result from the asynchronous function, that illustrates how you can access either API from within an asynchronous function context.

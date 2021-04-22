---
date: 2020-01-14 00:00
---

#  Check if app is running unit tests the Swift way

While writing unit tests for function in my [framework](https://github.com/TheInkedEngineer/BloodyMary), I ran into a problem in the following function:

```
public func pushViewController( 
_ viewController: UIViewController, 
animated: Bool, 
completion: (() -> Void)?
) {
  self.pushViewController(viewController, animated: animated)
  
  guard animated, let coordinator = self.transitionCoordinator else {
    DispatchQueue.main.async { completion?() }
    return
  }
  
  coordinator.animate(alongsideTransition: nil) { _ in completion?() }
}
```

When writing tests that might invoke this function, 
with the animated parameter set to *bool*, in a normal behavior `self.transitionCoordinator != nil` when `animated: true`, 
but since no actual transition is happening (in a unit test), it is *nil*, and it breaks the completion block.

So I needed a way to set animation to *false*, even if it was set to *true* from the outside during unit tests. `#if DEBUG` was not an option, obviously.
I did further digging and noticed that if you run `Thread.current.threadDictionary` 
the thread running the *XCTest* contains the following key: `com.apple.dt.xctest.waiter-manager` 

So I wrote this extension:

```
extension Thread {
  var isRunningXCTest: Bool {
    for key in self.threadDictionary.allKeys {
      guard let keyAsString = key as? String else {
        continue
      }
    
      if keyAsString.split(separator: “.”).contains(“xctest”) {
        return true
      }
    }
    return false
  }
}
```

I opted to check for *xctest* alone and not the whole key to future proof it, from any possibile changes to the key.

So now the code looks like this:

```
public func pushViewController( 
_ viewController: UIViewController, 
animated: Bool, 
completion: (() -> Void)?
) {
  if Thread.current.isRunningXCTest {
    self.pushViewController(viewController, animated: false)
  } else {
    self.pushViewController(viewController, animated: animated)
  }
  
  guard animated, let coordinator = self.transitionCoordinator else {
    DispatchQueue.main.async { completion?() }
    return
  }
  
  coordinator.animate(alongsideTransition: nil) { _ in completion?() }
}
```

---
date: 2019-04-16 00:00
---

#  Write better Swift code with: Precondition

It might sound weird at first, but most often then not, it is better to let your app crash, then let it continue in an inconsistent state. 
It is even easier to debug a problem when a crash occurs, and you know where the crash is, compared to having an unexpected end result, 
where you have to guess where the error came from.

An efficient, elegant way to do so, is to use Swift’s Standard Library function — `precondition(_:_:file:line:)`.

Below is an example on how to use precondition and how it can make your code look better and more compact:

```
func circumferenceOfCircle(with radius: Int) -> Double {
  precondition(radius > 0, "Radius can not be negative")
  return 2 * Double.pi * Double(radius)
}


circumfrenceOfCircle(with: -3)
// Precondition failed: Radius can not be negative: file MyPlayground.playground, line 2

//SOLUTION WITH GUARD
//func circumferenceOfCircle(with radius: Int) -> Double {
//  guard radius > 0 else {
//    fatalError("Radius can not be negative")
//  }
//  return 2 * Double.pi * Double(radius)
//}
```

- If we don’t put any control at all, we risk calculating a negative circumference which would then fuck everything up. Besides, by definition, a radius can not be negative.

- Guard + fatalError would have gave us the same result, but precondition is more compact.

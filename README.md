A Library for handling errors in SwiftUI Interfaces.

Like NavigationLink(_, value:) .navigationDestination(for:,_) but for error handling


# Usage

## Basic Usage
Check The Docc Documentation for more information on how to throw and catch errors

```swift
WithErrorHandling { errors in
    errors.push(URLError(.cancelled))
}
.onCatch(of: URLError.self) { err in
    print("Oh Oh", err)
}
```

## Error Throwing & Catching Views
SwiftUIError also provides convenient wrappers around basic SwiftUI Views & View Modifiers
like Button, Alert & Task

```swift
ThrowingButton("Press Me") {
    throw URLError(.cancelled)
}
.alert("A URLError occured", for: URLError.self, message: { error in
    switch error {
        case .cancelled:
            Text("The Operation was cancelled")
            
        default:
            Text("Unknown Error")
    }
})
```

## View Hierarchy

An error can only be caught **once**. Error Catching Views will only push unknown errors upstream.
This makes it possible to have multiple handlers for one error type.

If an error get's pushed all the way upstream without being caught it will emit a runtime warning (when debugging)

You can also add an `onCatch()` modifier without specifying an error type to catch any Error: 

```swift
VStack {
    ThrowingButton("Not Caught at all") {
        throw URLError(.cancelled)
    }
        
    VStack {
        ThrowingButton("Caught by 1") {
            throw URLError(.cancelled)
        }
        .onCatch(of: URLError.self) { _ in }    // 1
        
        ThrowingButton("Caught by 2") {
            throw URLError(.cancelled)
        }
        
        ThrowingButton("Caught by 3") { 
            throw MyError()
        }
    }
    .onCatch(of: URLError.self) { _ in }        // 2
    
    .onCatch { error in                         // 3
        print("Unhandled Error", error)
    }
}

```

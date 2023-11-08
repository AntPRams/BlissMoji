# iMoji

Exploring Skills: BlissApps evaluation project

## Table of Contents
- [Demo](#demo)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Tests](#tests)
- [Roadmap](#roadmap)
- [Final thoughts](#final-thoughts)
- [References](#references)

## Demo

<p align="center">
<img src="https://github.com/AntPRams/iMoji/assets/36003116/272394c6-0c31-4728-8788-af12baf9e218" width="18%%">  <img src="https://github.com/AntPRams/iMoji/assets/36003116/e554c5ea-b2be-4710-89d0-57a9aeed2b18" width="18%%">  <img src="https://github.com/AntPRams/iMoji/assets/36003116/e03b8053-a959-4d04-9226-adc4c19471ee" width="18%%">  <img src="https://github.com/AntPRams/iMoji/assets/36003116/7b60e529-75e5-4537-aa9e-e05e704a015f" width="18%%">  <img src="https://github.com/AntPRams/iMoji/assets/36003116/30a8326b-c81c-4e37-bde0-cdd31cf480c8" width="18%%">
</p>

## Getting Started

This project was developed with [Xcode](https://developer.apple.com/xcode/resources/) 15.0.1 for iOS 17. 

I've integrated some of the latest features of Swift 5.9, such as `SwiftData` and the new Observation macros. This app was designed with reusability in mind, and above all, I aimed to create a project with a robust foundation.

## Usage

This project was built using the MVVM architecture with a strong emphasis on dependency injection. All reusable objects implement an interface, allowing the use of mocks in tests or reusing similar objects for the same purposes.
  
For instance:
```swift
protocol Service: AnyObject {
    
    associatedtype DataType: Decodable
    func fetchData(from endPoint: EndPoint) async throws -> DataType
    func fetchImage(from url: URL) async throws -> Data
}
```

The example above is related to the interface of all services used in communication with the API layer. This approach allow us to maintain a generic interface for all API requests, like this:

```swift	
class SomeService: Service {
    // code…
}

let service = SomeService<SomeModel>()
```
 The main goal was to keep all elements separate while making them as generic as possible. For example, the view is unaware of the existence of the repositories, the view only interacts with the ViewModel. Similarly, the ViewModel doesn't handle persistence; that responsibility is managed by the repository.

Here's a simple diagram depicting the app's layers and how data flows:

![iMoji diagram](https://github.com/AntPRams/iMoji/assets/36003116/6617142e-f9d2-4d61-a650-64bf8a3b8dcb)

To store data, I decided to explore `SwiftData`. Currently, `SwiftData` works well wthin processes executed on the main thread, especially if implemented in the View layer. However, I aimed to separate concerns, so I'm using a `PersistentDataSource` exposed to the @MainActor. This allows me to execute instructions safely outside the view layer. Unfortunately, `SwiftData` is not yet ready for production, particularly when working with more complex data structures.

On the other hand, SwiftData is simpler and easier to use than CoreData.

To create a repository, you only need to do this:

```swift
let container = try! ModelContainer(for: MediaItem.self)
        
self.modelContainer = container
self.modelContext = ModelContext(modelContainer)
```

And then expose the models to the `@Model` macro. It's that simple! 💫

However, like SwiftUI, I'm concerned that we might have to wait a few more years (I hope not) before it can be used in production safely.

## Tests  

Below, there’s a screenshot with the test coverage, the remaining tests are mainly related to UI objects. Check the [Roadmap](#roadmap) 

<img width="1148" alt="Screenshot 2023-11-08 at 12 33 54" src="https://github.com/AntPRams/iMoji/assets/36003116/a6050b56-7b96-4a0d-a5c6-a13e84a562d4">

In some tests class's `MainViewModelTests` you’ll see a lot of:; 

```swift
try await Task.sleep(nanoseconds: 300_000_000)
```

This was necessary, for now, as there isn’t an easy way to test published properties in classes exposed to the `@Observable` macro, as we had with `@ObservableObject` and `@Published` property wrapper. There is a solution, but to implement it, I had to pollute the viewModel properties with `didSet` observers to track the values, or mock every viewModel with loads of boilerplate code. That's why I decided to use `Task.sleep`.  

You can read more [here](https://forums.swift.org/t/tracking-properties-in-observable-models-internally/66743)

## Roadmap

* Accessibility:  Nowadays, there’s no excuse in a production environment. It’s a fundamental aspect of good design, and it’s crucial to ensure that the apps we work on are accessible to everyone. I didn’t have time to do it, but it’s one aspect that I truly value.
* Logs: They are extremely helpful in a development environment, but this was one of those things that I left behind, and when I wanted to pick them up, well, it was too late.
* UI Tests: As I mentioned before, the app has an 87% test coverage, and the remaining tests are mainly related to the UI. It's very easy to test SwiftUI views with just a couple of lines of code. For example, if I wanted to test the error when tapping the search avatar button without text in the search field, I could do something like this:  

```swift
func test_searchAvatar() throws {
        //given
        let originTextField = app.textFields[“avatar”SearchFielld]
        let searchButton = app.buttons["searchButton"]
        let alertView = app.alerts.firstMatch
        
        //when
        searchButton.tap()
        
        //then
        XCTAssertEqual(alertView.label, "Please perform a user search with results.”)
        alertView.buttons.firstMatch.tap()
    }
```

These are some of the improvements that I would have liked to implement before shipping the app to you, but I didn't want to keep you waiting.

## Final thoughts

I had a lot of fun developing this app, especially because in our profession, there are few opportunities to use the latest features, apart from our personal projects, but those are also scarce nowadays. Time is not our friend.

I could have used `UIKit` and `CoreData` to develop the app, but I wanted to take this opportunity to push my boundaries. It wasn’t an easy task, mainly due to the scarcity of documentation and the insufficiency or lack of context in the existing one. However, that's also part of the appeal – the challenge.  😊
 
I hope you have as much fun reviewing the project as I had while creating it. The business logic is well-documented to assist you in this process.
 
 I’m always available for any clarification, please don’t hesitate to reach out if you need anything from my end. 

Thank you for the opportunity, I look forward to speaking with you soon! 

## References

- [SwiftData by example](https://www.hackingwithswift.com/quick-start/swiftdata)
- [Dive deeper into SwiftData](https://developer.apple.com/videos/play/wwdc2023/10196/)
- [Observation](https://developer.apple.com/videos/play/wwdc2023/10149/)
- [Demystify SwiftUI performance](https://developer.apple.com/videos/play/wwdc2023/10160)
- [Observation Docs](https://developer.apple.com/documentation/observation)
- [SwiftData Docs](https://developer.apple.com/documentation/swiftdata)

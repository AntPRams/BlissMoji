# iMoji

Exploring Skills: BlissApps evaluation project

## Table of Contents
- [Demo](#getting-started)
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

I have incorporated some of the latest features of Swift 5.9, such as `SwiftData` and the new `Observable` macros, this app was developed with reusability in mind and above all I aimed to develop a project with a solid foundation.

## Usage

This project was developed using the MVVM architecture with a focus on employing dependency injection. 
All reusable objects implement an interface with the intention of enabling the use of mocks in tests or reusing similar objects for the same purposes.  
eg:  

```swift
protocol Service: AnyObject {
    
    associatedtype DataType: Decodable
    func fetchData(from endPoint: EndPoint) async throws -> DataType
    func fetchImage(from url: URL) async throws -> Data
}
```

The example above is related to the interface of all services used in the communication with the API layer.  This approach allow us to maintain a generic interface for all API requests, like this;

```swift	
class SomeService: Service {
    // code…
}

let service = SomeService<SomeModel>()
```
 The main goal was to keep all elements separated while striving to make them as generic as possible.  As an example, the view does not know about the existence of the repositories, the view only interacts with the ViewModel, also, the ViewModel does not know anything about persistence, that responsibility is handled by the repository.

Here's is a simple diagram with the app layers and how the data flows:

![iMoji diagram](https://github.com/AntPRams/iMoji/assets/36003116/6617142e-f9d2-4d61-a650-64bf8a3b8dcb)

 To store the data I’ve decided to try `SwiftData` . For now `SwiftData` works well within processes executed in the main thread, specially if it’s implemented in the View layer. However, I really wanted to separate concerns and that's why I’m using a class (`PersistentDataSource`) exposed to the `@MainActor`. With this I can execute instructions safely and outside the view layer. But, unfortunately, `SwiftData` is not yet ready to production, specially if working with more complex data structures.

In other hand `SwiftData` is way simpler than `CoreData`.

To create a repository we just need to:

```swift
let container = try! ModelContainer(for: MediaItem.self)
        
self.modelContainer = container
self.modelContext = ModelContext(modelContainer)
```

And then expose the models to the `@Model` macro.

Is that simple! 💫

But like SwiftUI, I fear that we still have to wait a few years (I hope not) until we can use it, saffely, in production.

## Tests  

Below there’s a screenshot with the tests coverage, the remainder is mainly related with UI objects, check [Roadmap](#roadmap) 

<img width="1148" alt="Screenshot 2023-11-08 at 12 33 54" src="https://github.com/AntPRams/iMoji/assets/36003116/a6050b56-7b96-4a0d-a5c6-a13e84a562d4">

In some tests class's - `MainViewModelTests` is a good example - you’ll see a lot of; 

```swift
try await Task.sleep(nanoseconds: 300_000_000)
```

This was necessary, for now, since there isn’t an easy way to test published properties in class’s exposed to the `Observable` macro as we had with `@ObservableObject` and `@Puslished` property wrapper. There is a solution, but to implement it I had to pollute the viewModel properties with `didSet` observer in order to track the values, or mock every viewModel with loads of boiler plate code. For that reason I decided to use `Task.sleep`. 
You can read more [here](https://forums.swift.org/t/tracking-properties-in-observable-models-internally/66743)

## Roadmap

* Accessibility: Nowadays there’s no excuse in a production environment, it’s a fundamental aspect of good design and it’s crucial to ensure that the apps we work on are accessible to everyone. I didn’t had time to do it, but it’s one aspect that I really value.
* Logs: They are extremely helpful on a development environment, but this was one of those things that I left behind, and when i wanted to pick them up, well, to late.
* UI Tests: As I stated before, the app as a 87% test coverage and the remainder is mainly related with the UI. Its very easy to test SwiftUI views with just a couple of lines of code. For example, if I wanted to test the error when tapping the search avatar button without text in the search field I could do something like;  

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

These were some of the improvements that I would liked to implement before shipping the app to you, but I didn't want to keep you waiting.

## Final thoughts

Had a lot of fun developing this app, specially because in our profession there are few opportunities to use the latest features, apart from our personal projects, but those are also scarce nowadays, time is not our friend.

I could use `UIKit` and `CoreData` to develop the app but I wanted seize this opportunity to push my boundaries, it wasn’t an easy task, mostly due due to the scarcity of documentation and the insufficiency or lack of context in the existing one, however, that's also part of the appeal – the challenge. 😊
 
I hope you have as much fun reviewing the project as I had while creating it. The business logic is well documented to help you on this process.
 
 I’m always available for any clarification, please don’t hesitate to reach out if you need anything from my end. 

Thank you for the opportunity, I look forward to speaking with you soon! 

## References

- [SwiftData by example](https://www.hackingwithswift.com/quick-start/swiftdata)
- [Dive deeper into SwiftData](https://developer.apple.com/videos/play/wwdc2023/10196/)
- [Observation](https://developer.apple.com/videos/play/wwdc2023/10149/)
- [Demystify SwiftUI performance](https://developer.apple.com/videos/play/wwdc2023/10160)
- [Observation Docs](https://developer.apple.com/documentation/observation)
- [SwiftData Docs](https://developer.apple.com/documentation/swiftdata)

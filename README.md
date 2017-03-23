# UserProfile
An iPhone app for iOS 10 that displays the user profile of an user.AS the below link is not accessible I followed the reasonable UI desgin of my own.
https://farepilottest.herokuapp.com/

# How to Run, Build and Test

The project can be run using Xcode 8.2 and built/tested using the standard Xcode build (⌘B) and test (⌘U) commands.
Local user profile JSON files are embedded in the test target to run the tests without relying on the network.
Summary of implementation details:

- Developed the App using Xcode 8.2 and Swift 3.0.

- Main focus on implementing right architecture, design patterns and performance of the App.

- Implemented UI modules using storyboards,stackview and auto layouts

 - Followed MVP based architecture- Model,View(View&ViewController) and Presenter

- Used dependency injection across the App to facilitate the unit testing of the classes.

 - Implemented unit tests using XCTestCase and Mock Objects.

 - Used NSURLSession for network operations.

 - Used ObjectMapper framework for parsing JSON data.

 - Used Reachability framework for network availability check.


# Further Improvements

The following are some of the improvements to the project that should be made given more time:

- Eye-catching UI elements
- Persist user profile to display in offline mode
- More unit tests for a complete coverage
- UI tests

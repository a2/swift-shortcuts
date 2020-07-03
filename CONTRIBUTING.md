# Contributing to _SwiftShortcuts_

The following is a set of guidelines for contributing to _SwiftShortcuts_ on GitHub.

> Above all, thank you for your interest in the project and for taking the time to contribute! 👍

## I want to report a problem or ask a question

This project does not come with GitHub Issues-based support, and users are instead encouraged to become active participants in its continued development — by fixing any bugs that they encounter, or by improving the documentation wherever it's found to be lacking.

If you have an issue with importing your shortcut into the Shortcuts app, feel free to [open a Pull Request](https://github.com/a2/swift-shortcuts/pull/new) with a new test case.

## I want to contribute to _SwiftShortcuts_

### Prerequisites

To develop _SwiftShortcuts_, you will need to use either a Swift toolchain or an Xcode version compatible with the Swift version specified in the [README](https://github.com/a2/swift-shortcuts/#contributing).

### Checking out the repository

- Click the "Fork" button in the upper right corner of repo
- Clone your fork:
    - `git clone https://github.com/<YOUR_GITHUB_USERNAME>/swift-shortcuts.git`
- Create a new branch to work on:
    - `git checkout -b <YOUR_BRANCH_NAME>`
    - A good name for a branch describes the thing you'll be working on, e.g. `add-action`, `fix-bug`, etc.

That's it! Now you're ready to work on _SwiftShortcuts_. If using Xcode, open the `Package.swift` file in Xcode. Otherwise you can use your favorite text editor to start coding.

### Things to keep in mind

- Always document new public types, methods and properties

### Testing your local changes

Before opening a pull request, please make sure your changes don't break things.

- The framework and tests should build without warnings
- The tests should pass on both macOS and Linux

### Submitting the PR

When the coding is done and you've finished testing your changes, you are ready to submit the PR to the [main repo](https://github.com/a2/swift-shortcuts). Some best practices are:

- Use a descriptive title
- Link the issues that are related to your PR in the body

## Code of Conduct

Help us keep _SwiftShortcuts_ open and inclusive. Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.

_These contribution guidelines were adapted from [_fastlane_](https://github.com/fastlane/fastlane) guidelines._

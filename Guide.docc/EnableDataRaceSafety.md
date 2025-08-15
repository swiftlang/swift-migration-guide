# Enabling data race safety checking

Enable data race safety checking for a new or existing Swift project.

## Overview

To enable data race safety checking for a new Swift project, use the Swift 6 language mode.
By default, Swift 6 enables full data race safety checking.

### Enabling Swift 6 language mode with Swift Package Manager

A `Package.swift` file that uses `swift-tools-version` of `6.0` enables the Swift 6 language mode for all targets. 
You can still set the language mode for the package as a whole using the `swiftLanguageModes` property of `Package`.
You can also change the language mode as needed on a per-target basis using the new `swiftLanguageMode` build setting:

```swift
// swift-tools-version: 6.0

let package = Package(
    name: "MyPackage",
    products: [
        // ...
    ],
    targets: [
        // Uses the default tools language mode (6)
        .target(
            name: "FullyMigrated",
        ),
        // Still requires 5
        .target(
            name: "NotQuiteReadyYet",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
```

Note that if your package needs to continue supporting earlier Swift toolchain versions and you want
to use per-target `swiftLanguageMode`, you will need to create a version-specific manifest for pre-6
toolchains. For example, if you'd like to continue supporting 5.9 toolchains and up, you could have
one manifest `Package@swift-5.9.swift`:
```swift
// swift-tools-version: 5.9

let package = Package(
    name: "MyPackage",
    products: [
        // ...
    ],
    targets: [
        .target(
            name: "FullyMigrated",
        ),
        .target(
            name: "NotQuiteReadyYet",
        )
    ]
)
```

And another `Package.swift` for Swift toolchains 6.0+:
```swift
// swift-tools-version: 6.0

let package = Package(
    name: "MyPackage",
    products: [
        // ...
    ],
    targets: [
        // Uses the default tools language mode (6)
        .target(
            name: "FullyMigrated",
        ),
        // Still requires 5
        .target(
            name: "NotQuiteReadyYet",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
```

If instead you would just like to use Swift 6 language mode when it's available (while still
continuing to support older modes) you can keep a single `Package.swift` and specify the version in
a compatible manner:
```swift
// swift-tools-version: 5.9

let package = Package(
    name: "MyPackage",
    products: [
        // ...
    ],
    targets: [
        .target(
            name: "FullyMigrated",
        ),
    ],
    // `swiftLanguageVersions` and `.version("6")` to support pre 6.0 swift-tools-version.
    swiftLanguageVersions: [.version("6"), .v5]
)
```

#### Enabling Swift 6 language mode with command-line invocations

`-swift-version 6` can be passed in a Swift package manager command-line
invocation using the `-Xswiftc` flag:

```
~ swift build -Xswiftc -swift-version -Xswiftc 6
~ swift test -Xswiftc -swift-version -Xswiftc 6
```

To enable the Swift 6 language mode when running `swift` or `swiftc`
directly at the command line, pass `-swift-version 6`:

```
~ swift -swift-version 6 main.swift
```

#### Enabling the Swift 6 language mode with Xcode

You can control the language mode for an Xcode project or target by setting
the "Swift Language Version" build setting to "6".

**XCConfig** 

You can also set the `SWIFT_VERSION` setting to `6` in an xcconfig file:

```
// In a Settings.xcconfig

SWIFT_VERSION = 6;
```

### Enabling Safety Checking with Swift 5 language mode

With a Swift target or package in Swift 5 language mode, you can address data-race safety issues in your projects on a module-by-module basis.
Enable the compiler's actor isolation and `Sendable` checking as warnings when using the Swift 5 language mode to assess your progress toward eliminating data races before turning on the Swift 6 language mode.

Complete data-race safety checking can be enabled as warnings in the Swift 5
language mode using the `-strict-concurrency` compiler flag.

#### Enabling Safety Checking with command-line invocations

To enable complete concurrency checking when running `swift` or `swiftc`
directly at the command line, pass `-strict-concurrency=complete`:

```
~ swift -strict-concurrency=complete main.swift
```

`-strict-concurrency=complete` can be passed in a Swift package manager
command-line invocation using the `-Xswiftc` flag:

```
~ swift build -Xswiftc -strict-concurrency=complete
~ swift test -Xswiftc -strict-concurrency=complete
```

This can be useful to gauge the amount of concurrency warnings before adding
the flag permanently in the package manifest as described in the following
section.

#### Enabling Safety Checking in a Package manifest

To enable complete concurrency checking for a target in a Swift package using
Swift 5.9 or Swift 5.10 tools, use [`SwiftSetting.enableExperimentalFeature`](https://docs.swift.org/swiftpm/documentation/packagedescription/swiftsetting/enableexperimentalfeature(_:_:))
in the Swift settings for the given target:

```swift
.target(
  name: "MyTarget",
  swiftSettings: [
    .enableExperimentalFeature("StrictConcurrency")
  ]
)
```

When using Swift 6.0 tools or later, use [`SwiftSetting.enableUpcomingFeature`](https://docs.swift.org/swiftpm/documentation/packagedescription/swiftsetting/enableupcomingfeature(_:_:))
in the Swift settings for a pre-Swift 6 language mode target:

```swift
.target(
  name: "MyTarget",
  swiftSettings: [
    .enableUpcomingFeature("StrictConcurrency")
  ]
)
```

Targets that adopt the Swift 6 language mode have complete checking
enabled unconditionally and do not require any settings changes.

#### Enabling Safety Checking using Xcode

To enable complete concurrency checking in an Xcode project, set the
"Strict Concurrency Checking" setting to "Complete" in the Xcode build
settings.

**XCConfig** 

Alternatively, you can set `SWIFT_STRICT_CONCURRENCY` to `complete`
in an xcconfig file:

```
// In a Settings.xcconfig

SWIFT_STRICT_CONCURRENCY = complete;
```

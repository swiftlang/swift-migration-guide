# Data race safety checking

Enable data race safety checking for a new or existing Swift project.

## For a new Swift project

To enable data race safety checking for a new Swift project, start with and use Swift 6.
By default, Swift 6 enables full data race safety checking.

See <doc:Swift6Mode> for further details and specifics about enabling and using the Swift 6 language mode.

## For an existing Swift project

For an existing Swift project prior to Swift 6, use [SwiftSetting.enableUpcomingFeature](https://docs.swift.org/swiftpm/documentation/packagedescription/swiftsetting/enableupcomingfeature(_:_:)) to enable the feature `StrictConcurrency` on the `swiftSettings` property of the target.
Apply the setting for the targets you for which you want to enable data race safety checking.

For example, a target within your Package.swift manifest might look like:

```swift
.target(
  name: "MyTarget",
  swiftSettings: [
    .enableUpcomingFeature("StrictConcurrency")
  ]
)
```

See <doc:CompleteChecking> to learn how to incrementally adopt concurrency checking to support incremental migration of an existing project.
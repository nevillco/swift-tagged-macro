# swift-tagged-macro

Provides a Swift macro wrapping some type declaration boilerplate in [swift-tagged](https://github.com/pointfreeco/swift-tagged#installation).

## Example

```swift
struct Person {

    #tagged(UUID.self, "ID")
    let id: ID

}
```
➡️ becomes:
```swift
struct Person {

    enum ID_Tag {
    }
    typealias ID = Tagged<ID_Tag, UUID>
    let id: ID

}
```

## Motivation

swift-tagged is a framework from the [PointFree](https://www.pointfree.co) folks which aims to increase the type safety of your Swift codebase. It’s a handy tool, but once you need to wrap the same raw value twice within the same context, you will need to disambiguate your `Tagged` type via some [additional boilerplate](https://github.com/pointfreeco/swift-tagged#handling-tag-collisions). The motivation behind this macro is to eliminate that little bit of boilerplate, to make it that much more appealing to adopt this layer of type safety in your project. 

## Usage

The macro declaration takes 3 parameters

## Gotchas

* Swift macros that introduce arbitrary names, like this one, [cannot be introduced at the global scope](https://github.com/apple/swift-evolution/blob/main/proposals/0389-attached-macros.md#visibility-of-names-used-and-introduced-by-macros). Of course, you can still declare those `Tagged` types manually. 

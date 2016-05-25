## LazyObject
[![Coverage Status](https://coveralls.io/repos/github/iwasrobbed/LazyObject/badge.svg?branch=master)](https://coveralls.io/github/iwasrobbed/LazyObject?branch=master)
[![Build Status](https://travis-ci.org/iwasrobbed/LazyObject.svg?branch=master)](https://travis-ci.org/iwasrobbed/LazyObject)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/iwasrobbed/LazyObject/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/LazyObject.svg?maxAge=2592000)]()
[![Swift](https://img.shields.io/badge/language-Swift-blue.svg)](https://swift.org)

Lazily deserialize JSON into strongly typed Swift objects, with a few getter style options.

Is your app using it? [Let me know!](mailto:rob@desideratalabs.co)

### Installation

Quickly install using [CocoaPods](https://cocoapods.org): 

```ruby
pod 'LazyObject'
```

### API

Let's look at an example model to show off some of the functionality:

```swift
class Bank: LazyObject {
    var money: Double       { return try! objectFor(#function) } // Automagically converts #function to a "money" string
    var getPaid: Bool?      { return try? objectFor("get_paid") } // Will be nil if called and key/value don't exist
    var security: [Person]? { return try? objectFor(#function) } // Works with arrays of other LazyObjects as well
    var debt: Double        { return try! objectFor("accounting.books.cooked") } // Nested key paths are supported 
}
```

Models are instantiated from JSON dictionaries:

```swift
// The dictionary passed here is the JSON response
let bank = Bank(dictionary: ["money": 9999, "get_paid": true])
```

There is also a convenience extension for instantiating from JSON arrays:

```swift
let banks = Bank.fromArray(jsonArrayOfDictionaries)
```

### Date Formattables

Since many services have varying date formats, LazyObject provides an easy way to specify which standard or custom format you'd like to conform to.

```swift
class Retirement: LazyObject, ISO8601Formattable {
  var date: NSDate?   { return try? dateFor(#function) }
}
```

**Note**: For dates, you must specifically use the `dateFor()` method so it will choose the correct formatter from the cache.

Any of your base or sub-classes can conform to *one* of the supported protocols:

* ISO8601Formattable (e.g. "2016-04-24T14:42:42.424Z")
* RFC3339Formattable (e.g. "2016-04-24T14:42:42Z")
* RFC1123Formattable (e.g. "Sun, 24 Apr 2016 14:42:42 +0000"")
* RFC850Formattable (e.g. "Sunday, 24-Apr-16 14:42:42 UTC")
* EpochFormattable (e.g. "1461508962.424" as a string or 1461508962.424 as a double)

Or you're free to extend `LazyDateFormattable` to create custom date conversions (look at how the above protocols are implemented for an example).

All formatters above are created once and cached for re-use, and it is recommended you do the same if you create custom formattables since they tend to be expensive to create.

### Key Getter Options

The `objectFor` method supports a couple variations for key names:

- `#function`: Converts whatever the property name is into a string (e.g. `var help` becomes `"help"`). Note that a property name like `myProperty` will be converted to `"myProperty"` not `my_property`, so feel free to extend LazyObject if you require that.
- `keyPath`: Can be a string containing a single key like `first_name` or a key path to a nested value like `location.latitude`

### Optionals

Notice in the example that you can use `try?` to ensure optional safety on the properties. If you're feeling confident, you can use `try!` to force it but you may receive one of a few runtime errors if it doesn't succeed.

### Convertibles

Aside from standard JSON data types, the following types are seamlessly supported:

* NSDate
* NSURL
* NSNumber

### Custom Convertibles

If you want to seamlessly convert a custom value, such as to create an `NSNumber` from a string value, you can create your own extensions of `LazyConvertible` like so:

```swift
// Note: this example is actually already part of the library, so no need to extend NSNumber

import Foundation

extension NSNumber: LazyConvertible {

    public static func convert(value: AnyObject?) throws -> NSNumber {
        guard let string = value as? String else {
            throw LazyMappingError.UnexpectedTypeError(value: value, type: String.self)
        }

        let formatter = NSNumberFormatter()
        guard let number = formatter.numberFromString(string) else {
            throw LazyMappingError.CustomError(message: "'\(string)' is not a valid input for NSNumber instantiation")
        }

        return number
    }

}
```

This will allow you to seamlessly support any type of valid `NSNumber`, whether from string or from a number value, just by using the normal `objectFor` methods.

### Setting Values

LazyObject is focused mostly on read-only models, but you can still easily expose a setter on the model if necessary:

```swift
class Object: LazyObject {
    var id: NSNumber? {
        get {
            return try? objectFor(#function)
        }
        set {
            setObject(newValue, setter: #function)
        }
    }
}
```

Note: Similar to the [getter methods](#key-getter-options), both the setter `#function` can be used or the `keyPath` can be used to reference the key name to update.

### Supports
Swift, ARC & iOS 9+

### A little help from my friends
Please feel free to fork and create a pull request for bug fixes or improvements, being sure to maintain the general coding style, adding tests, and adding comments as necessary.

### Credit
This library is influenced by [CottonObject](https://github.com/hermiteer/CottonObject) and [Mapper](https://github.com/lyft/mapper)
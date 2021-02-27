# DiffableWithReload
Automated reloadItems for diffable datasources
-
iOS 13.0 introduced new diffable data source that can be used with UITableView and UICollectionView. Table/Collection view is updated by applying a snapshot containing section and items identifiers, thus easily allows insertion/removal/move of sections and items. Cell reload is also supported, however it is fully on the developer to identify the items that need reload and add these items to the snapshot that will be applied.

DiffableWithReload subclasses UITableViewDiffableDataSource and UICollectionViewDiffableDataSource, and *automates identification of the items that need reload.*

So, you do not need to care about items reload at all. This subclassed data source does it for you.

Classes
-
Use these generic classes:

``` swift
TableViewDiffableReloadingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, EquatableCellContent: Equatable>

CollectionViewDiffableReloadingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, EquatableCellContent: Equatable>
```

The idea
-
The basic idea of automated items reload generation for diffable datasources is the following:

* for each cell _used_ in the table/collection view is stored the displayed content
* when snapshot is being applied, the current (stored) cell content is compared to the current data source content, and if these are not equal, cell must be reloaded
* the `EquatableCellContent` is the content stored for each _used_ cell in the table/collection view. It can be anything `Equatable`, but for practical reasons, there are two structs creating equatable content:
* `EncodableContent` creating `Data?` from the specified properties - `Data?` are unique identifier of the displayed content and can be easily created from any `Encodable` property.
* `HashableContent` creating `Int` from the specified properties (the hash value) - `hashValue` is _not so unique_ identifier of the displayed content, however, maybe is good enough, and integer storage and comparation is a bit faster than the `Data?` store and compare. Default choice should be `EncodableContent`.


Basic Example
-
```swift
// diffable datasource providing details about various cars is initialized

// change data in the cars array
cars.changeColorOfAllCars(brand: Self.volkswagen)
// and just apply the current snapshot
let snapshot = diffableDataSource.snapshot()
// items for reload are automatically created
diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: false)
```

See the demo project for more examples.
The example project uses type aliases for these two classes, and, unfortunately, quick help in Xcode does not show quick help from the original generic classes.


Setup Instructions
------------------

[CocoaPods](http://cocoapods.org)
------------------

To integrate Toast-Swift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DiffableWithReload', '~> 0.2'
```

and in your code use `import DiffableWithReload`.

[Swift Package Manager](https://swift.org/package-manager/)
------------------

When using Xcode 11 or later, you can install `DiffableWithReload` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`


Compatibility
------------------
* Example project uses multiple trailing closures and requires Swift 5.3
* Version `0.x.x` requires Swift 5
 
# DiffableWithReload
##Automated call of reloadItems(_:) for diffable datasources

The new (iOS 13+) diffable datasources are great step forward making UITableView and UICollectionView much easier to use. Except one operation: item reloads.

##Why

Modern app architectures store data in some kind of ViewModel or ViewStore ([The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture), [CombineFeedback](https://github.com/sergdort/CombineFeedback), and many others), while the UI just observes the data.

Very likely, the ViewModel/ViewStore:

* stores data that should be displayed in table/collection view, often transformed or enriched (this data is usually private to the ViewModel/ViewStore)
* there is an array of section identifiers
* and a dictionary of item identifiers (section identifier is the key)

Thanks to the diffable datasources [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource) and [UICollectionViewDiffableDataSource](UICollectionViewDiffableDataSource), animated updating the table/collection view is very easy:

* create new [snapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot)
* set [sectionIdentifiers](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3375786-sectionidentifiers)
* set [itemIdentifiers](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3375774-itemidentifiers)
* call [reloadItems(_:)](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot/3375783-reloaditems) on the snapshot

The only troubled step is the last one: **Which items have to be reloaded?**

DiffableWithReload automates identification of items that require reload, so you do not need to care about reloading. Cells needing reload (and only these) are automatically reloaded (when snapshot is applied).

##Classes

DiffableWithReload subclasses [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource) and [UICollectionViewDiffableDataSource](UICollectionViewDiffableDataSource) (still as generic classes) so you can use them with your data types.

For basic use, there are available:

``` swift
TableViewDiffableReloadingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, EquatableCellContent: Equatable>

CollectionViewDiffableReloadingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, EquatableCellContent: Equatable>
```

For advanced use, when you need (for example) data locking, there are available these subclasses:

``` swift
TableViewDiffableDelegatingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, Delegate: ReloadingDataSourceDelegate, EquatableCellContent: Equatable>

CollectionViewDiffableDelegatingDataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, Delegate: ReloadingDataSourceDelegate, EquatableCellContent: Equatable>
```

##Examples

```swift
// change data in the cars array
cars.changeColorOfAllCars(brand: .volkswagen)
// apply the current snapshot
let snapshot = diffableDataSource.snapshot()
// items for reload are automatically created
diffableDataSource.applyWithItemsReloadIfNeeded(snapshot, animatingDifferences: true)
```

It is highly recommended to review the example code. There are 3 tabs in the example iOS application:

* First tab (Cars): Elementary example where you can see on 100 lines of code, how it works
* Second tab (Cars and Motorcycles): Close to real-world example, with view model and Combine used for observing the changes.
* Third tab (Motorcycles): Demonstrating use with collection view and more cell reuse identifiers.

Under the hood (How it works)
-

* for each cell *used* in the table/collection view is stored the displayed content
* displayed content is generic type `EquatableCellContent` (conforming to `Equatable`)
* when snapshot is being applied, the currently displayed cell content is compared to the current data source content, and if these are not equal, cell will be reloaded
* DiffableWithReload temporarily stores the displayed cell content (`EquatableCellContent`) for each _used_ cell in the table/collection view. Again, it can be any type conforming to `Equatable`, but there are two handy structs creating equatable content:
* `EncodableContent` creating `Data?` value from the specified properties: `Data?` is unique identifier of the displayed content and can be easily created from any `Encodable` property of your underlaying data. The provided `data` value is an Optional, because `encode(to:)` may throw. In such a case the cell is always reloaded.
* `HashableContent` creating `Int` (the hash) value from the specified properties: `hashValue` is _not so unique_ identifier of the displayed content, however, may be good enough. Default choice should be `EncodableContent`.


##Setup Instructions

###[CocoaPods](http://cocoapods.org)

To integrate Toast-Swift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DiffableWithReload', '~> 1.0'
```

and in your code use `import DiffableWithReload`.

###[Swift Package Manager](https://swift.org/package-manager/)

When using Xcode 11 or later, you can install `DiffableWithReload` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`


##Compatibility

* Version `1.0` requires Swift 5
* Example project uses multiple trailing closures and requires Swift 5.3
 
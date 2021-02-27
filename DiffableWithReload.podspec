
Pod::Spec.new do |spec|

  spec.name         = "DiffableWithReload"
  spec.version      = "0.1"
  spec.summary      = "An automated items reload for UITableView and UICollectionView when diffable data source is used. iOS 13.0+"

  spec.description  = <<-DESC
  iOS 13.0 introduced new diffable data source that can be used with UITableView and UICollectionView. Table/Collection view is updated by
  applying a snapshot containing section and items identifiers, thus easily allows insertion/removal/move of sections and items.
  Cell reload is also supported, however it is fully on the developer to identify the items that need reload and add these items
  to the snapshot that will be applied.

  This pod subclasses UITableViewDiffableDataSource and UICollectionViewDiffableDataSource and automates identification of the items
  that need reload. So, you do not need to care about item reload at all. This subclasseddata source does it for you.
                   DESC

  spec.homepage     = "https://github.com/hibernat/DiffableWithReload"
  spec.license      = "MIT"
  spec.author       = { "Michael Bernat" => "michael@hibernat.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  # spec.osx.deployment_target = "10.7"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/hibernat/DiffableWithReload.git", :tag => spec.version }
  spec.source_files  = "DiffableWithReload", "DiffableWithReload/**/*.swift"
  
end

//
//  HashableContent.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 18.02.2021.
//

/**
 Once `HashableContent` is initialized, use its `.hashValue` property to get the identifier
 representing the content specified by the keyPaths. The `hashValue` is not guaranteed to be
 unique, so it may happen that some cells representing different source data have the same `hashValue`
 and such a cells would __NOT be reloaded__.
 
 This is a known weakness of using the `hashValue` as
 an "not so unique identifier" for cell content. The case of the same the `hashValue` computed from
 different source data is quite unlikely, but still is possible. Using the `hashValue` as an unique identifier
 is definitely not recommended for live saving applications, however can work quite well in many other areas
 where some rare missing cell reload could be acceptable.
 
 The advantage of `HashableContent` over `Equatable Content` is its performace and small memory allocation.
 
 *This structure can be seen  as a factory providing customized hash values.*
 
 The other structure, the `EncodableContent` structure, provides `.data` property from the custom
 keyPaths. The `.data` property is guaranteed to be unique for the selected keyPaths, with reasonable
 performance. Memory allocation depends on the source used for computing the `EncodableContent.data`
 Always use `EncodableContent` except cases where performace has absolute priority and/or
 the `EncodableContent`data is very large, or number of __used__ cells is very high.
 */
public struct HashableContent<
    Root,
    Value0: Hashable,
    Value1: Hashable,
    Value2: Hashable,
    Value3: Hashable,
    Value4: Hashable,
    Value5: Hashable,
    Value6: Hashable,
    Value7: Hashable,
    Value8: Hashable,
    Value9: Hashable
>: Hashable {
    
    private var value0: Value0
    private var value1: Value1
    private var value2: Value2
    private var value3: Value3
    private var value4: Value4
    private var value5: Value5
    private var value6: Value6
    private var value7: Value7
    private var value8: Value8
    private var value9: Value9
    
    /// HashableContent created from an instance of any struct/class and one hashable keyPath.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(of root: Root, using keyPath: KeyPath<Root, Value0>)
    where Value1 == Int, Value2 == Int, Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath]
        value1 = 0
        value2 = 0
        value3 = 0
        value4 = 0
        value5 = 0
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and two hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(of root: Root, using keyPath0: KeyPath<Root, Value0>, _ keyPath1: KeyPath<Root, Value1>)
    where Value2 == Int, Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = 0
        value3 = 0
        value4 = 0
        value5 = 0
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and three hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(of root: Root, using keyPath0: KeyPath<Root, Value0>, _ keyPath1: KeyPath<Root, Value1>, _ keyPath2: KeyPath<Root, Value2>)
    where Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = 0
        value4 = 0
        value5 = 0
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and four hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>
    ) where Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = 0
        value5 = 0
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and five hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>
    ) where Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = 0
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and six hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>,
        _ keyPath5: KeyPath<Root, Value5>
    ) where Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = root[keyPath: keyPath5]
        value6 = 0
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and seven hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>,
        _ keyPath5: KeyPath<Root, Value5>,
        _ keyPath6: KeyPath<Root, Value6>
    ) where Value7 == Int, Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = root[keyPath: keyPath5]
        value6 = root[keyPath: keyPath6]
        value7 = 0
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and eight hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>,
        _ keyPath5: KeyPath<Root, Value5>,
        _ keyPath6: KeyPath<Root, Value6>,
        _ keyPath7: KeyPath<Root, Value7>
    ) where Value8 == Int, Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = root[keyPath: keyPath5]
        value6 = root[keyPath: keyPath6]
        value7 = root[keyPath: keyPath7]
        value8 = 0
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and nine hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>,
        _ keyPath5: KeyPath<Root, Value5>,
        _ keyPath6: KeyPath<Root, Value6>,
        _ keyPath7: KeyPath<Root, Value7>,
        _ keyPath8: KeyPath<Root, Value8>
    ) where Value9 == Int {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = root[keyPath: keyPath5]
        value6 = root[keyPath: keyPath6]
        value7 = root[keyPath: keyPath7]
        value8 = root[keyPath: keyPath8]
        value9 = 0
    }
    
    /// HashableContent created from an instance of any struct/class and ten hashable keyPaths.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(
        of root: Root,
        using keyPath0: KeyPath<Root, Value0>,
        _ keyPath1: KeyPath<Root, Value1>,
        _ keyPath2: KeyPath<Root, Value2>,
        _ keyPath3: KeyPath<Root, Value3>,
        _ keyPath4: KeyPath<Root, Value4>,
        _ keyPath5: KeyPath<Root, Value5>,
        _ keyPath6: KeyPath<Root, Value6>,
        _ keyPath7: KeyPath<Root, Value7>,
        _ keyPath8: KeyPath<Root, Value8>,
        _ keyPath9: KeyPath<Root, Value9>
    ) {
        value0 = root[keyPath: keyPath0]
        value1 = root[keyPath: keyPath1]
        value2 = root[keyPath: keyPath2]
        value3 = root[keyPath: keyPath3]
        value4 = root[keyPath: keyPath4]
        value5 = root[keyPath: keyPath5]
        value6 = root[keyPath: keyPath6]
        value7 = root[keyPath: keyPath7]
        value8 = root[keyPath: keyPath8]
        value9 = root[keyPath: keyPath9]
    }
    
    /// HashableContent created by supplying a value.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0) where Value1 == Int, Value2 == Int, Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = 0
        self.value2 = 0
        self.value3 = 0
        self.value4 = 0
        self.value5 = 0
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying two values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1) where Value2 == Int, Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = 0
        self.value3 = 0
        self.value4 = 0
        self.value5 = 0
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying three values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2) where Value3 == Int, Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = 0
        self.value4 = 0
        self.value5 = 0
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying four values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3) where Value4 == Int, Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = 0
        self.value5 = 0
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying five values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4) where Value5 == Int, Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = 0
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying six values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4, value5: Value5) where Value6 == Int, Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = 0
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying seven values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4, value5: Value5, value6: Value6) where Value7 == Int, Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = 0
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying eight values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4, value5: Value5, value6: Value6, value7: Value7) where Value8 == Int, Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = 0
        self.value9 = 0
    }
    
    /// HashableContent created by supplying nine values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4, value5: Value5, value6: Value6, value7: Value7, value8: Value8) where Value9 == Int {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = value8
        self.value9 = 0
    }
    
    /// HashableContent created by supplying ten values.
    /// Use `.hashValue` on the created HashableContent as an 'almost unique` equatable identifier.
    public init(value0: Value0, value1: Value1, value2: Value2, value3: Value3, value4: Value4, value5: Value5, value6: Value6, value7: Value7, value8: Value8, value9: Value9) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = value8
        self.value9 = value9
    }
    
}

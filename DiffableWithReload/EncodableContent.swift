//
//  EquatableContent.swift
//  DiffableWithReload
//
//  Created by Michael Bernat on 11.02.2021.
//

import Foundation

/**
 Once `EncodableContent` is initialized, use its `.data` property to get the unique equatable identifier
 representing the content specified by the keyPaths.
 
 `EncodableContent` intentionally does not conform to Equatable nor Hashable protocols
 but data provided by the `.data` property are both equatable and hashable,
 and are expected to be used as an unique identifier.
 
 *This structure can be seen  as a factory providing customized unique identifiers.*
 
 The other structure, the `HashableContent` structure, provides `hashValue` from the selected keyPaths.
 `hashValue` is not guaranteed to be unique (some cells may not be reloaded!),
 but has lower memory allocation, and runs a bit faster.
 
 The `EncodableContent` provides data that uniquely represent the content, still with very good performance
 and low memory allocation. Always use `EncodableContent` except cases where performace has
 absolute priority and/or the `EncodableContent`data is very large, or number of __used__ cells is very high
 */
public struct EncodableContent<
    Root,
    Value0: Encodable,
    Value1: Encodable,
    Value2: Encodable,
    Value3: Encodable,
    Value4: Encodable,
    Value5: Encodable,
    Value6: Encodable,
    Value7: Encodable,
    Value8: Encodable,
    Value9: Encodable
>: Encodable {
        
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
    
    /// Data expected to be used as an unique equatable identifier only.
    public var data: Data? {
        try? PropertyListEncoder().encode(self)
    }
    
    /// EncodableContent created from an instance of any struct/class and one encodable keyPath.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and two encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and three encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and four encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and five encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and six encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and seven encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and eight encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and nine encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created from an instance of any struct/class and ten encodable keyPaths.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying a value.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying two values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying three values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying four values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying five values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying six values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying seven values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying eight values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying nine values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    /// EncodableContent created by supplying ten values.
    /// Use `.data` on the created EncodableContent for data used as an unique equatable identifier.
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(value0)
        try container.encode(value1)
        try container.encode(value2)
        try container.encode(value3)
        try container.encode(value4)
        try container.encode(value5)
        try container.encode(value6)
        try container.encode(value7)
        try container.encode(value8)
        try container.encode(value9)
    }
}

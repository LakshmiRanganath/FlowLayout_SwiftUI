import SwiftUI

public struct ViewWidth: Equatable {
    let index: Int
    let width: CGFloat
}

public struct ViewHeight: Equatable {
    let index: Int
    let height: CGFloat
}

public struct ViewWidthKey: PreferenceKey {
    public typealias Value = [ViewWidth]

    public static var defaultValue: [ViewWidth] = []

    public static func reduce(value: inout [ViewWidth], nextValue: () -> [ViewWidth]) {
        value.append(contentsOf: nextValue())
    }
}

public struct WordWidthKey: PreferenceKey {
    public typealias Value = [ViewWidth]

    public static var defaultValue: [ViewWidth] = []

    public static func reduce(value: inout [ViewWidth], nextValue: () -> [ViewWidth]) {
        value.append(contentsOf: nextValue())
    }
}

public struct ViewHeightKey: PreferenceKey {
    public typealias Value = [ViewHeight]

    public static var defaultValue: [ViewHeight] = []

    public static func reduce(value: inout [ViewHeight], nextValue: () -> [ViewHeight]) {
        value.append(contentsOf: nextValue())
    }
}

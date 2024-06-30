import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func attachViewHeightPreferenceSetter() -> some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: ViewHeightKey.self,
                                value: [ViewHeight(index: 0, height: geometry.size.height)])
            }
            self
        }
    }
    func attachViewWidthPreferenceSetter() -> some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: ViewWidthKey.self,
                                value: [ViewWidth(index: 0, width: geometry.size.width)])
            }
            self
        }
    }

    func attachWordWidthPreferenceSetter(index: Int) -> some View {
        self
            .background(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .preference(key: WordWidthKey.self,
                                    value: [ViewWidth(index: index, width: geometry.size.width)])
                }
        )
    }
}

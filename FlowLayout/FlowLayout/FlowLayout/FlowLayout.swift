import SwiftUI

public struct FlowLayout<Item: FlowLayoutItem, ItemView: View>: View {
    @ObservedObject public var model: FlowLayoutModel<Item>
    public var spaceBetweenRows: CGFloat = 24
    public let itemView: (Item) -> ItemView
    public let overFlowAction: (() -> Void)?
    
    public init(model: FlowLayoutModel<Item>, spaceBetweenRows: CGFloat = 24, overflowAction: (() -> Void)? = nil, @ViewBuilder itemView: @escaping (Item) -> ItemView) {
        self.model = model
        self.spaceBetweenRows = spaceBetweenRows
        self.itemView = itemView
        self.overFlowAction = overflowAction
    }
    
    @ViewBuilder
    public var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spaceBetweenRows) {
                    ForEach(self.model.flowedWords.indices, id: \.self) { (lineIndex: Int) in
                        HStack(alignment: .top, spacing: self.model.spacingBetweenWords) {
                            ForEach(self.model.flowedWords[lineIndex].indices, id: \.self) { (wordIndex: Int) in
                                if model.isOverFlowPresent, lineIndex == model.maxRows - 1, self.model.flowedWords[lineIndex].last == self.model.flowedWords[lineIndex][wordIndex] {
                                    OverFlowPill(text: self.model.flowedWords[lineIndex][wordIndex], buttonAction: overFlowAction)
                                } else if let item = self.model.items.first(where: { $0.displayName == self.model.flowedWords[lineIndex][wordIndex] }) {
                                         itemView(item)
                                }
                            }
                        }
                        .frame(maxWidth: self.model.viewWidth, alignment: .leading)
                    }
                }
                .padding(.horizontal, model.paddingConstant)
                .attachViewHeightPreferenceSetter()
            }
            .attachViewWidthPreferenceSetter()
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(self.model.items.indices, id: \.self) { (itemIndex: Int) in
                        itemView(self.model.items[itemIndex])
                        .attachWordWidthPreferenceSetter(index: itemIndex)
                    }
                }.onPreferenceChange(WordWidthKey.self) { preferences in
                    self.model.widths = preferences.sorted(by: { $0.index < $1.index }).map { $0.width.rounded(.up) }
                    self.model.reflow()
                }
            }.opacity(0)
            .onAppear {
                self.model.items = self.model.items
            }
        }.onPreferenceChange(ViewWidthKey.self) { preferences in
            self.model.viewWidth = min(preferences.first?.width ?? 0, UIScreen.main.bounds.width)
            self.model.reflow()
        }
        .onPreferenceChange(ViewHeightKey.self) { preferences in
            if self.model.totalHeight != nil {
                self.model.totalHeight = (preferences.last?.height ?? 0) + 20
            }
        }
        .frame(maxHeight: self.model.totalHeight)
        .frame(maxWidth: self.model.maxWidth)
    }
}

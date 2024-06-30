import SwiftUI

public struct OverFlowPill: View {
    public var text: String
    public var buttonAction: (() -> Void)?
    
    public init(text: String, buttonAction: (() -> Void)? = nil) {
        self.text = text
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        Button(action: {
            buttonAction?()
        }, label: {
            Text(text)
                .font(.subheadline)
                .overFlowPillStyle()
        })
    }
}

public struct OverFlowPillModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.purple)
            )
            .frame(maxHeight: 32)
            .foregroundColor(Color.white)
    }
}

extension View {
    public func overFlowPillStyle() -> some View {
        self.modifier(OverFlowPillModifier())
    }
}


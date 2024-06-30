import Foundation
import SwiftUI

public protocol FlowLayoutItem: Equatable {
    var displayName: String { get }
}

public class FlowLayoutModel<Item: FlowLayoutItem>: ObservableObject {
    @Published public var flowedWords: [[String]] = []
    public var widths: [CGFloat] = []
    public var viewWidth: CGFloat = 0
    public let spacingBetweenWords: CGFloat = 16
    public var maxRows: Int
    public var shouldShowOverFlowCount = true
    public var paddingConstant: CGFloat = 16
    public var items: [Item] = []
    public var maxWidth: CGFloat?
    @Published public var totalHeight: CGFloat?
    @Published public var isOverFlowPresent = false
    
    public init(items: [Item], maxRows: Int = Int.max, maxWidth: CGFloat? = nil, totalHeight: CGFloat? = nil) {
        self.items = items
        self.maxRows = maxRows
        self.maxWidth = maxWidth
        self.totalHeight = totalHeight
        if maxWidth == nil {
            self.paddingConstant /= 2
        }
        self.viewWidth = min(maxWidth ?? .greatestFiniteMagnitude, UIScreen.main.bounds.width)
        self.reflow()
    }
    
    var words: [String] {
        return items.map { $0.displayName }
    }
}

extension FlowLayoutModel {
    func reflow() {
        guard !words.isEmpty else { flowedWords = []; return }
        guard !self.widths.isEmpty else {
            flowedWords = [words]
            return
        }
        
        var breakIndices: [Int] = []
        var lineWidth: CGFloat = self.widths[0]
        for (index, width) in self.widths.dropFirst().enumerated() {
            if lineWidth + width + spacingBetweenWords + (paddingConstant * 2) < viewWidth {
                lineWidth += width + spacingBetweenWords + (paddingConstant * 2)
            } else {
                breakIndices.append(index + 1)
                lineWidth = width
            }
        }
        
        if breakIndices.isEmpty {
            flowedWords = [words]
        } else {
            flowedWords = breakIndices.indices.map { index in
                let lowerBound = index == 0 ? 0 : breakIndices[index - 1]
                let upperBound = breakIndices[index]
                let range = lowerBound..<upperBound
                return Array(words[range])
            }
            flowedWords.append(Array(words[breakIndices.last!..<words.count]))
        }
        
        if flowedWords.count > maxRows {
            flowedWords = Array(flowedWords.prefix(maxRows))
            if shouldShowOverFlowCount {
                handleOverFlowCountDisplay()
            }
        }
    }
    
    private func handleOverFlowCountDisplay() {
        var remainingWordsCount = self.words.count - self.flowedWords.flatMap { $0 }.count
        
        if remainingWordsCount > 0 {
            isOverFlowPresent = true
            var morePillText = "+\(remainingWordsCount) more"
            let morePillWidth = (morePillText as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]).width + spacingBetweenWords + (paddingConstant * 2)
            
            while let lastLine = flowedWords.last, !lastLine.isEmpty {
                let lastLineWidth = lastLine.reduce(0) { $0 + widths[words.firstIndex(of: $1)!] + spacingBetweenWords + (paddingConstant * 2)} + spacingBetweenWords + (paddingConstant * 2)
                
                if lastLineWidth + morePillWidth <= viewWidth {
                    morePillText = "+\(remainingWordsCount) more"
                    flowedWords[maxRows - 1].append(morePillText)
                    return
                } else {
                    flowedWords[maxRows - 1].removeLast()
                    remainingWordsCount += 1
                }
            }
            
            flowedWords[maxRows - 1].append(morePillText)
        }
    }
}

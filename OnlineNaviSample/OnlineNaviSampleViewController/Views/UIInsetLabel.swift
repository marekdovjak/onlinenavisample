import Foundation
import UIKit

class UIInsetLabel: UILabel {
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height + contentInset.top + contentInset.bottom)
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}

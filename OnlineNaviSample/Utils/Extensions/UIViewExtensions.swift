import Foundation
import UIKit

//MARK: - Safe Area
public extension UIView {
    
    public class var statusBarHeight: CGFloat {
        if UIApplication.shared.isStatusBarHidden {
            return 0
        }
        
        let statusFrame = UIApplication.shared.statusBarFrame
        return min(statusFrame.height, statusFrame.width)
    }
    
    public var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    
    public var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
    
    public var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    public var validSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets(top: UIView.statusBarHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    public var unsafeAreaStatusBarOffset: CGFloat {
        if #available(iOS 11.0, *) {
            // if using safeAreaLayoutGuide == we are safe
            return 0.0
        } else {
            if(UIApplication.shared.isStatusBarHidden) {
                return 0.0
            }
            let frame = UIApplication.shared.statusBarFrame
            return min(frame.size.width, frame.size.height)
        }
    }
    
    func coverWholeSuperview(withMargin margin: CGFloat = 0) {
        if superview == nil {
            return
        }
        
        let metrics = ["margin": margin]
        superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[self]-(margin)-|", options: .alignAllCenterY, metrics: metrics, views: ["self": self]))
        superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(margin)-[self]-(margin)-|", options: .alignAllCenterX, metrics: metrics, views: ["self": self]))
    }
}

////MARK: - Introinspectable
//public extension UIView {
//    
//    /**
//     This method will introinspect the view tree looking for a subview with the given substring class name, if there
//     is no subivew with that substring class it will return nil
//     - parameters:
//        - nameSubstring: The substring to look for
//        - view: the view to instroinspect
//     - returns: UIView wich class corresponds to a match of the nameSubstring parameter
//     */
//    public func findSubviewWith(classNameSubstring nameSubstring:String, in view:UIView) -> UIView? {
//        for subview in view.subviews {
//            let stringName =  String(describing: subview)
//            if stringName.range(of: nameSubstring) != nil {
//                return subview
//            }
//            else {
//                return findSubviewWith(classNameSubstring: nameSubstring, in: subview)
//            }
//        }
//        return nil
//    }
//}
//
// MARK: - Corners & Shadows
public extension UIView {

//    private static let cornerRadius: CGFloat = 16.0
    private static let shadowRadius: CGFloat = 4.0
//
//    // MARK: Corners
//    
//    /// Round corners by default corner radius.
//    public func roundCorners() {
//        layer.cornerRadius = UIView.cornerRadius
//    }
//    
//    /// Round corners by half of the size to create fully rounded corners.
//    public func fullRoundCorners() {
//        let cornerRadius = min(bounds.width, bounds.height) / 2.0
//        layer.cornerRadius = cornerRadius
//    }
//    
//    // MARK: Shadows
//    
//    /// Creates `shadowPath` with default corner radius.
//    public func roundShadowPath() {
//        layer.shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: UIView.cornerRadius).cgPath
//    }
//    
//    /// Creates `shadowPath` with fully rounded corners.
//    public func fullRoundShadowPath() {
//        let cornerRadius = min(bounds.width, bounds.height) / 2.0
//        layer.shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//    }
//    
    /// Adds default shadow for "floating" controls
    public func setupDefaultShadow() {
        setupShadow(with: UIView.shadowRadius)
    }

    /// Adds shadow with specific radius
    public func setupShadow(with radius: CGFloat) {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
//
//    /// Adds default shadow as transparent border from bottom and right side
//    public func setupShadowBorder() {
//        layer.shadowColor = UIColor.barShadow.cgColor
//        layer.shadowOpacity = 1.0
//        layer.shadowRadius = 0.0
//        layer.shadowOffset = CGSize(width: 1, height: 1)
//        layer.masksToBounds = false
//    }
//    
//    /// Adds default shadow as transparent border from top and right side
//    public func setupShadowTopBorder() {
//        setupShadowBorder()
//        layer.shadowOffset = CGSize(width: 1, height: -1)
//    }
//}
//
//// MARK: - Extended hit area
//public extension UIView {
//    
//    /**
//     This method will look if point is located around extended view area
//     - parameters:
//        - point: point around area (point is in actual view coordinate system)
//     - returns: Boolean value, if given point is located in extended view area
//     */
//    public func containsAdjusted(point: CGPoint) -> Bool {
//        var viewFrame = bounds
//        viewFrame.origin.x -= 8.0
//        viewFrame.origin.y -= 8.0
//        viewFrame.size.width += 16.0
//        viewFrame.size.height += 16.0
//        return viewFrame.contains(point)
//    }
}


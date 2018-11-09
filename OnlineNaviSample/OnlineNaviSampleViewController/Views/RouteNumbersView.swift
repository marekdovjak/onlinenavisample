import UIKit
import SygicMaps
import SwiftSVG

public class RouteNumberView: UIView {
    private let svgSize: CGFloat = 28.0
    
    private var shape: SYNumberShapeType? {
        didSet {
            if oldValue?.rawValue == shape?.rawValue {
                return
            }
            
            if let shape = shape, let url = Bundle(for: RouteNumberView.self).url(forResource: RouteNumberView.shapeToSVG(shape: shape), withExtension: "svg", subdirectory: "roadSigns") {
                let _ = CALayer(SVGURL: url) { [unowned self] svgLayer in
                    self.signLayer = svgLayer
                }
            } else {
                signLayer = nil
            }
        }
    }
    
    private var signLayer: SVGLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if let signLayer = signLayer {
                layer.insertSublayer(signLayer, below: numberLabel.layer)
            }
        }
    }
    
    private let numberLabel = UIInsetLabel()
    
    public init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textAlignment = .center
        numberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        numberLabel.font = SygicFonts.with(SygicFonts.bold, size: 14.0)
        addSubview(numberLabel)
        heightAnchor.constraint(equalToConstant: svgSize).isActive = true
        numberLabel.contentInset = UIEdgeInsets.init(top: 0, left: 6, bottom: 0, right: 6)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numberLabel]|", options: [], metrics: nil, views: ["numberLabel": numberLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[numberLabel]|", options: [], metrics: nil, views: ["numberLabel": numberLabel]))
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if let signLayer = signLayer {
            var scaleFactorX = layer.frame.size.width / signLayer.boundingBox.width
            let scaleFactorY = layer.frame.size.height / signLayer.boundingBox.height
            
            if shape == .usaShield {
                scaleFactorX *= 1.5
            }
            
            signLayer.transform = CATransform3DMakeScale(scaleFactorX, scaleFactorY, 1.0)
        }
    }
    
    public func update(with format: SYRouteNumberFormat?) {
        if let format = format {
            numberLabel.text = format.insideNumber
            numberLabel.textColor = RouteNumberView.numberColor(from: format.numberColor)
            shape = format.shape
        } else {
            shape = nil
            numberLabel.text = nil
            numberLabel.textColor = nil
        }
    }
    
    public class func shapeToSVG(shape: SYNumberShapeType) -> String {
        switch shape {
        case .blueShape1: return ""//
        case .greenEShape3: return "are-green-white-border"
        case .greenEShape2: return "hun-green-white-border"
        case .blueNavyShape2: return "hun-blue-white-border"
        case .greenAShape4: return "aus-4-green"
        case .blueShape5: return "aus-2-blue"
        case .blueShape6: return "deu"
        case .redShape5: return "nzl-red-white-border"
        case .redShape6: return "tur"
        case .redShape8: return "che-red-white-border"
        case .redShape9, .redShape10: return "rect-red"
        case .greenEShape6: return "svn"
        case .brownShape7: return "aus-1-brown"
        case .blueRedCanShape: return "can-8"
        case .blackShape11WhiteBorder: return "aus-4-black"
        case .whiteShape12BlueNavyBorder: return "aus-5-white-black-border"//
        case .yellowShape13GreenABorder: return "aus-5-green-yellow-border"//
        case .whiteShape14GreenEBorder: return "can-9"
        case .whiteShape15BlackBorder: return "can-3"
        case .greenEShape16WhiteBorder, .greenEShape18WhiteBorder: return "ita"
        case .whiteShape17BlackBorder, .whiteShape24BlackBorder: return ""//
        case .blueShape17WhiteBorder: return "isr-blue-white-border"
        case .blueShape18BlackBorder: return "vnm"//
        case .yellowShape18BlackBorder: return "mys"
        case .orangeShape19BlackBorder: return ""//
        case .whiteShape20BlackBorder: return "nld-white-black-border"
        case .whiteShape22BlackBorder: return "usa-white-black-border-1"
        case .whiteShape21BlackBorder: return "usa-white-black-border-2"
        case .orangeShape23WhiteBorder: return "hkg-orange-white-border"
        case .whiteShape24BlueMexBorder: return "isr-white-blue-border"
        case .whiteShape24RedBorder: return "isr-white-red-border"
        case .whiteShape24GreenEBorder: return "isr-white-green-border"
        case .redMexShape, .blueMexShape: return"mex"
        case .usaShield: return "usa-blue-red-border"//
        case .greenESauShape1: return ""//
        case .greenESauShape2: return ""//
        case .greenESauShape3: return ""//
        case .whiteRect, .whiteRectBlackBorder: return "rect-white-black-border"
        case .whiteRectGreenEBorder: return "rect-white-green-border"
        case .whiteRectYellowBorder: return "rect-white-yellow-border"
        case .blueRect, .blueNavyRect, .blueRectWhiteBorder, .blueNavyRectWhiteBorder: return "rect-blue"
        case .blueRectBlackBorder: return "rect-blue-black-border"
        case .redRect, .redRectWhiteBorder: return "rect-red"
        case .redRectBlackBorder: return "rect-red-black-border"
        case .brownRect: return "rect-brown"
        case .orangeRect: return "rect-orange"
        case .yellowRect, .yellowRectWhiteBorder: return "rect-yellow"
        case .yellowRectBlackBorder: return "rect-yellow-black-border"
        case .greenERectBlackBorder: return "rect-green-black-border"
        case .greenARect, .greenERect, .greenERectWhiteBorder, .greenARectGreenEBorder, .unknown: return "rect-green"
            
        }
    }
    
    public class func numberColor(from shapeColor: SYNumberTextColor) -> UIColor {
        switch shapeColor {
        case .black: return .black
        case .white, .unknown: return .white
        case .greenA, .greenE: return UIColor(red:0.00, green:0.60, blue:0.40, alpha:1.0)
        case .blue, .blueMex, .blueNavy: return UIColor(red:0.00, green:0.50, blue:1.00, alpha:1.0)
        case .red: return UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
        case .yellow: return UIColor(red:0.94, green:0.94, blue:0.00, alpha:1.0)
        case .orange: return UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
        case .brown: return UIColor(red:0.60, green:0.00, blue:0.00, alpha:1.0)
        }
    }
}

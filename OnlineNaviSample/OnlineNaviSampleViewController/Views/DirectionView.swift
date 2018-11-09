import UIKit
import SygicMaps

public class DirectionView: UIView {
    public var iconSize: CGFloat = 60.0
    public var waypointLetterSize: CGFloat = 20.0
    
    private var mainDirection = UILabel()
    private var helperDirection = UILabel()
    private var waypointLetter = UILabel()

    private var layoutConstraints = [NSLayoutConstraint]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func initDefaults() {
        backgroundColor = .clear
        
        mainDirection = createLabel(withColor: .white, andFont: SygicFonts.with(SygicFonts.iconFont, size: 60))
        helperDirection = createLabel(withColor: mainDirection.textColor.withAlphaComponent(0.5) , andFont: SygicFonts.with(SygicFonts.iconFont, size: 60))
        waypointLetter = createLabel(withColor: .lightGray, andFont: SygicFonts.with(SygicFonts.bold, size: waypointLetterSize))
        
        for label: UILabel in [helperDirection, mainDirection, waypointLetter] {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(constraints())
    }

    public func createLabel(withColor color: UIColor, andFont font: UIFont?) -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }
    
    public func constraints() -> [NSLayoutConstraint] {
        var layoutConstraints = [NSLayoutConstraint]()
        let bottomMargin = CGFloat(16.0)
        let bottomMarginWaypoint = CGFloat(12.0)
        let bindings = ["waypointLetter" : waypointLetter, "helperDirection" : helperDirection, "mainDirection" : mainDirection]
        
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[helperDirection]|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainDirection]|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[waypointLetter]|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(helperDirection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomMargin))
        layoutConstraints.append(mainDirection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomMargin))
        layoutConstraints.append(waypointLetter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomMarginWaypoint))
        
        return layoutConstraints
    }
    
    public func updateDirections(mainDirection: String?, helperDirection: String?, waypointLetter: String?) {
        self.mainDirection.text = mainDirection
        self.helperDirection.text = helperDirection
        self.waypointLetter.text = waypointLetter
    }
    
    public func setTextColor(_ color: UIColor?) {
        if let color = color {
            helperDirection.textColor = color.withAlphaComponent(0.5)
            mainDirection.textColor = color
        }
    }
}

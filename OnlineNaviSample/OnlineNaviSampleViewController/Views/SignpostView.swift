import UIKit
import SygicMaps

public class SignpostView: UIView {
    private let distanceLabel = UILabel()
    private let titleLabel = UILabel()
    private let routeSymbolsView = UIStackView()
    private var routeNumbers = [RouteNumberView]()
    private var pictograms = [UILabel]()
    private var centeredView = UIView()
    
    private let titleLabelOneLineFont = SygicFonts.with(SygicFonts.semiBold, size: 28.0)
    private let titleLabelTwoLineFont = SygicFonts.with(SygicFonts.semiBold, size: 18.0)
    
    public convenience init() {
        self.init(frame: .zero)
        
        initDefaults()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        adjustTitleLabel()
    }
    
    private func initDefaults() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabelOneLineFont
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        adjustTitleLabel()
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.allowsDefaultTighteningForTruncation = true
        distanceLabel.setContentHuggingPriority(.required, for: .horizontal)
        distanceLabel.textColor = .white
        
        routeSymbolsView.translatesAutoresizingMaskIntoConstraints = false
        routeSymbolsView.alignment = .trailing;
        routeSymbolsView.spacing = 4;
        
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(centeredView)
        centeredView.addSubview(distanceLabel)
        centeredView.addSubview(titleLabel)
        centeredView.addSubview(routeSymbolsView)
        
        NSLayoutConstraint.activate(constraints())
        
        addRouteNumbers(DirectionSignpostViewModel.routeNumbersMaxCount)
        addPictograms(DirectionSignpostViewModel.pictogramsMaxCount)
    }
    
    private func constraints() -> [NSLayoutConstraint] {
        let bindings = ["distanceLabel": distanceLabel, "titleLabel": titleLabel, "routeSymbolsView": routeSymbolsView, "centeredView": centeredView]
        var layoutConstraints = [NSLayoutConstraint]()
        
        layoutConstraints.append(NSLayoutConstraint(item: centeredView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: centeredView.superview, attribute: .top, multiplier: 1.0, constant: 0.0))
        layoutConstraints.append(NSLayoutConstraint(item: centeredView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: centeredView.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[centeredView]|", options: [], metrics: nil, views: bindings))
        
        distanceLabel.font = SygicFonts.with(SygicFonts.bold, size: 36.0)
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.minimumScaleFactor = 0.7
        
        if let superview = centeredView.superview {
            centeredView.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
        
        layoutConstraints.append(NSLayoutConstraint(item: distanceLabel, attribute: .top, relatedBy: .equal, toItem: distanceLabel.superview, attribute: .top, multiplier: 1.0, constant: -4.0))
        layoutConstraints.append(NSLayoutConstraint(item: distanceLabel, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1.0, constant: 4.0))
        layoutConstraints.append(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: titleLabel.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[distanceLabel]-(>=4)-[routeSymbolsView]-(8)-|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]-(8)-|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0@999)-[routeSymbolsView]-(>=0@999)-[titleLabel]|", options: [], metrics: nil, views: bindings))
        layoutConstraints.append(routeSymbolsView.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor))
        
        return layoutConstraints
    }
    
    public func setTextColor(_ color: UIColor) {
        distanceLabel.textColor = color
        titleLabel.textColor = color
        pictograms.forEach{ $0.textColor = color }
    }

    //MARK: - private methods
    private func updateRouteNumbers(with formats: [SYRouteNumberFormat]) {
        for (index, view) in routeNumbers.enumerated() {
            if formats.indices.contains(index) {
                view.update(with: formats[index])
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    private func updatePictograms(with pictograms: [String]) {
        for (index, view) in self.pictograms.enumerated() {
            if pictograms.indices.contains(index) {
                view.text = pictograms[index]
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
    private func addRouteNumbers(_ count: Int) {
        routeNumbers.removeAll()
        for _ in 0...count - 1 {
            let view = RouteNumberView()
            routeSymbolsView.addArrangedSubview(view)
            routeNumbers.append(view)
        }
    }
    
    private func addPictograms(_ count: Int) {
        pictograms.removeAll()
        for _ in 0...count - 1 {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.font = SygicFonts.with(SygicFonts.iconFont, size: 28.0)
            routeSymbolsView.addArrangedSubview(view)
            pictograms.append(view)
        }
    }
    
    private func adjustTitleLabel() {
        titleLabel.numberOfLines = OrientationUtils.isLandscape() ? 1 : 2
    }
    
    private func setTitleFont() {
        // Because we need number of visible lines with bigger font
        self.titleLabel.font = self.titleLabelOneLineFont
        if self.titleLabel.numberOfVisibleLines != 1 {
            self.titleLabel.font = self.titleLabelTwoLineFont
        }
    }
}

// MARK: -Navigation Data
extension SignpostView {
    public func updateDistance(distance: String) {
        distanceLabel.text = distance
    }

    public func updateTitle(title: String) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            let attrString = NSMutableAttributedString(string: title)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
            self.titleLabel.attributedText = attrString
            self.setTitleFont()
            self.titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    public func updateRouteSymbols(numbers: [SYRouteNumberFormat], pictograms: [String]) {
        let filteredPictograms = Array(pictograms.prefix(DirectionSignpostViewModel.pictogramsMaxCount))
        let filteredNumbers = Array(numbers.prefix(DirectionSignpostViewModel.routeNumbersMaxCount - filteredPictograms.count))
        self.updateRouteNumbers(with: filteredNumbers)
        self.updatePictograms(with: filteredPictograms)
    }
}

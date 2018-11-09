import UIKit
import SygicMaps

@objc public class DirectionSignpostContainer: UIView {
    private static let height: CGFloat = 88.0
    
    private let directionView = DirectionView()
    private let signpostView = SignpostView()
    private let directionWidth: CGFloat = 92.0
    private let viewModel = DirectionSignpostViewModel()
    
    //MARK: - Lifecycle
    public convenience init() {
        self.init(frame: .zero)
        self.setupDefaultShadow()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupDirectionView()
        setupSignpostView()
        
        refreshUI()
    }
    
    private func setupDirectionView() {
        directionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(directionView)
        directionView.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        directionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupSignpostView() {
        signpostView.translatesAutoresizingMaskIntoConstraints = false
        signpostView.isUserInteractionEnabled = false
        addSubview(signpostView)
        directionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        var constr = [NSLayoutConstraint]()
        constr.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[directionView][signpostView]|",
                                                                     options: [],
                                                                     metrics: nil,
                                                                     views: ["directionView": directionView,
                                                                             "signpostView":signpostView]))
        
        constr.append(directionView.widthAnchor.constraint(equalToConstant: directionWidth))
        
        constr.append(signpostView.topAnchor.constraint(equalTo: safeTopAnchor, constant: unsafeAreaStatusBarOffset))
        constr.append(signpostView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6))
        constr.append(bottomAnchor.constraint(equalTo: safeTopAnchor, constant: DirectionSignpostContainer.height + unsafeAreaStatusBarOffset))
        
        NSLayoutConstraint.activate(constr)
    }
}

// MARK: -Navigation data
extension DirectionSignpostContainer {
    public func udpateDirections(instruction: SYInstruction?) {
        viewModel.update(with: instruction)
        refreshUI()
    }
    
    public func updateSignposts(signposts: [SYSignpost]?) {
        viewModel.update(with: signposts)
        refreshUI()
    }
    
    private func refreshUI() {
        directionView.updateDirections(mainDirection: viewModel.mainDirectionSymbol, helperDirection: viewModel.helperDirectionSymbol, waypointLetter: viewModel.waypointLetterSymbol)
        signpostView.updateDistance(distance: viewModel.distance)
        signpostView.updateTitle(title: viewModel.signpostTitle.isEmpty ? viewModel.directionTitle : viewModel.signpostTitle)
        signpostView.updateRouteSymbols(numbers: viewModel.routeNumbers, pictograms: viewModel.pictograms)
        directionView.setTextColor(viewModel.textColor)
        signpostView.setTextColor(viewModel.textColor)
        
        self.backgroundColor = viewModel.backgroundColor
        self.isHidden = viewModel.isEmpty()
    }
}

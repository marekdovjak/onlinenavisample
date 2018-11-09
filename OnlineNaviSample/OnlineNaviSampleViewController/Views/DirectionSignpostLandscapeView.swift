import UIKit
import SygicMaps

class DirectionSignpostLandscapeView: SignpostView {
    
    private let mainStackView = UIStackView()
    private let signpostStackView = UIStackView()
    private let nextDirectionStackView = UIStackView()
    private let directionView = DirectionView()
//    private let nextDirectionView = NextDirectionView()
    private let thenLabel = UILabel()
    
    private let titleFontSize: CGFloat = 28.0
    private let sideMargin: CGFloat = 16.0
    
//    public func setupRxForDirectionAndSignpost(with viewModel: DirectionSignpostContainerDataSource) {
//        disposeBag = DisposeBag()
//
//        routeSymbolsView.removeAll()
//        addRouteNumbers(viewModel.routeNumbersMaxCount)
//        addPictograms(viewModel.pictogramsMaxCount)
//
//        viewModel.isEmpty.asDriver()
//            .drive(onNext: { [unowned self] isEmpty in
//                self.alpha = isEmpty ? 0 : 1
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.backgroundColor.asDriver()
//            .drive(onNext: { [unowned self] backgroundColor in
//                self.backgroundColor = backgroundColor
//            })
//            .disposed(by: disposeBag)
//
//        directionView.setupRx(with: viewModel)
//        nextDirectionView.setupRx(with: viewModel)
//
//        viewModel.title.asDriver()
//            .drive(onNext: { [unowned self] title in
//                self.titleLabel.text = title
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.distance.asDriver()
//            .drive(onNext: { [unowned self] title in
//                if title.count > 0 {
//                    self.distanceLabel.text = title
//                }
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.textColor.asDriver()
//            .drive(onNext: { [unowned self] textColor in
//                self.setTextColor(textColor)
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(viewModel.routeNumbers.asObservable(), viewModel.pictograms.asObservable())
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] routeNumbers, pictograms in
//                let filteredPictograms = Array(pictograms.prefix(viewModel.pictogramsMaxCount))
//                let filteredNumbers = Array(routeNumbers.prefix(viewModel.routeNumbersMaxCount - filteredPictograms.count))
//                self.updateRouteNumbers(with: filteredNumbers)
//                self.updatePictograms(with: filteredPictograms)
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.nextManeuver.asDriver()
//            .drive(onNext: { [unowned self] maneuver in
//                var showNextDirection = false
//                if let maneuver = maneuver {
//                    let symbols = maneuver.toSymbols()
//                    showNextDirection = !symbols.isEmpty || maneuver.type == .end || maneuver.type == .via
//                }
//
//                if showNextDirection {
//                    self.mainStackView.addArrangedSubview(self.nextDirectionStackView)
//                } else {
//                    self.mainStackView.removeArrangedSubview(self.nextDirectionStackView)
//                    self.nextDirectionStackView.removeFromSuperview()
//                }
//            })
//            .disposed(by: disposeBag)
//    }
    
    override internal func initDefaults() {
        clipsToBounds = true
//        roundCorners()
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        addSubview(mainStackView)
        mainStackView.coverWholeSuperview()
        
        setupSignpostWithDirection()
        setupNextDirection()
        
        mainStackView.addArrangedSubview(signpostStackView)
    }
    
    override func setTextColor(_ color: UIColor) {
        super.setTextColor(color)
//        directionView.setTextColor(color, maneuverType: nil)
//        nextDirectionView.setTextColor(color, maneuverType: nil)
        thenLabel.textColor = color
    }
    
    override public func applyConstraints(toOrientation: UIInterfaceOrientation) {
    }
    
    override internal func addPictograms(_ count: Int) {
        super.addPictograms(count)
        routeSymbolsView.addArrangedSubview(UIView())
    }
    
    override internal func adjustTitleLabel() {
    }
    
    // MARK: - Private
    
    private func setupSignpostWithDirection() {
        
        signpostStackView.translatesAutoresizingMaskIntoConstraints = false
        signpostStackView.distribution = .fill
        signpostStackView.alignment = .fill
        signpostStackView.axis = .vertical
        signpostStackView.spacing = 4
        signpostStackView.layoutMargins = UIEdgeInsets(top: 10, left: sideMargin, bottom: 4, right: sideMargin)
        signpostStackView.isLayoutMarginsRelativeArrangement = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = SygicFonts.with(SygicFonts.regular, size: titleFontSize)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        setupDirectionDistance()
        signpostStackView.addArrangedSubview(titleLabel)
        
        setupRouteSymbols()
        
        let space = UIView()
        space.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        signpostStackView.addArrangedSubview(space)
    }
    
    private func setupDirectionDistance() {
        
        directionView.translatesAutoresizingMaskIntoConstraints = false
        directionView.applyConstraints(toOrientation: UIInterfaceOrientation.landscapeLeft)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.minimumScaleFactor = 0.9
        distanceLabel.font = SygicFonts.with(SygicFonts.semiBold, size: 36.0)
        distanceLabel.setContentHuggingPriority(.required, for: .vertical)
        distanceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let directionStackView = UIStackView()
        directionStackView.translatesAutoresizingMaskIntoConstraints = false
        directionStackView.alignment = .fill
        directionStackView.spacing = 8.0
        directionStackView.setContentHuggingPriority(.required, for: .vertical)
        directionStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: -8, right: 0)
        directionStackView.isLayoutMarginsRelativeArrangement = true
        
        directionStackView.addArrangedSubview(directionView)
        directionStackView.addArrangedSubview(distanceLabel)
        
        signpostStackView.addArrangedSubview(directionStackView)
    }
    
    private func setupRouteSymbols() {
        routeSymbolsView.translatesAutoresizingMaskIntoConstraints = false
        routeSymbolsView.alignment = .center;
        routeSymbolsView.spacing = 4;
        
        signpostStackView.addArrangedSubview(routeSymbolsView)
    }
    
    private func setupNextDirection() {
        
        nextDirectionStackView.translatesAutoresizingMaskIntoConstraints = false
        nextDirectionStackView.alignment = .center
        nextDirectionStackView.spacing = 8.0
        nextDirectionStackView.layoutMargins = UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
        nextDirectionStackView.isLayoutMarginsRelativeArrangement = true
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.backgroundColor = .textInvertSubtitle
        nextDirectionStackView.addSubview(backgroundView)
        backgroundView.coverWholeSuperview()
        
//        nextDirectionView.translatesAutoresizingMaskIntoConstraints = false
//        nextDirectionView.applyConstraints(toOrientation: UIInterfaceOrientation.landscapeLeft)
//        nextDirectionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        thenLabel.translatesAutoresizingMaskIntoConstraints = false
        thenLabel.font = SygicFonts.with(SygicFonts.semiBold, size: 20)
        thenLabel.text = "signpost.nextDirection.then".localized()
        thenLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        thenLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        nextDirectionStackView.addArrangedSubview(thenLabel)
//        nextDirectionStackView.addArrangedSubview(nextDirectionView)
        nextDirectionStackView.addArrangedSubview(UIView())
        
        nextDirectionStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

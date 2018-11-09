import SygicMaps

class OnlineNaviSampleViewController : UIViewController {
    public var from: SYGeoCoordinate?
    public var to: SYGeoCoordinate?
    public var appKey: String?
    public var appSecret: String?
    
    private var mapView: SYMapView?
    private var routing: SYRouting?
    private var mapRoute: SYMapRoute?
    private var lastPosition: SYPosition?
    private var recenterButton: RecenterButton?
    private var signpost: DirectionSignpostContainer?
    private var signpostWidth: NSLayoutConstraint?
    private var signpostTop: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SYContext.initWithAppKey(appKey!, appSecret: appSecret!) { (initResult) in
            if initResult == .success {
                self.sygicInitSuccess()
            } else {
                self.showMessage(message: initResult.localizedDescription())
            }
        }
    }
    
    private func sygicInitSuccess() {
        SYOnlineSession.shared ().onlineMapsEnabled = true
        SYPositioning.shared().delegate = self
        SYPositioning.shared().startUpdatingPosition()
        SYNavigation.shared().delegate = self
        
        addSubviews()
        routing = SYRouting()
        routing?.delegate = self
        
        computeRoute()
    }

    private func showMessage(message: String, title: String? = nil, quit: Bool = true) {
        let alert = UIAlertController(title: title != nil ? title : "error".localized(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { (act) in
            if(quit) {
                self.stopNavigation()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func stopNavigation() {
        SYContext.terminate()
        dismiss(animated: true, completion: nil)
    }
    
    private func computeRoute() {
        let routingOptions = SYRoutingOptions()
        routingOptions.computeAlternativeRoutes = false
        
        routing!.computeRoute(SYWaypoint.init(position: from!, type: .start, name: nil),
                                   to: SYWaypoint.init(position: to!, type: .end, name: nil),
                                   via: nil, with: routingOptions)
    }
    
    private func navitateWithRoute(route: SYRoute) {
        if mapRoute != nil {
            mapView?.remove(mapRoute!)
        }
        
        SYNavigation.shared().start(with: route)

        //Navigation demonstration
//        let posSim = SYRoutePositionSimulator.init(route: route)
//        posSim?.speedMultiplier = 4.0
//        SYPositioning.shared().dataSource = posSim
//        SYPositioning.shared().startUpdatingPosition()
        
        mapRoute = SYMapRoute.init(route: route, type: .primary)
        mapView?.add(mapRoute!)
    }
}

// MARK: -UI
extension OnlineNaviSampleViewController {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateLayout()
    }
    
    private func addSubviews () {
        addMapView()
        addRecenterButton()
        addSignpostView()
    }
    
    private func addMapView() {
        mapView = SYMapView(frame: view.frame, geoCenter: from!, rotation: 0, zoom: 17, tilt: 0)
        mapView!.translatesAutoresizingMaskIntoConstraints = false
        mapView!.delegate = self
        view.addSubview(mapView!)
        view.sendSubviewToBack(mapView!)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[map]|", options: [], metrics: nil, views: ["map" : mapView!]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[map]|", options: [], metrics: nil, views: ["map" : mapView!]))
    }
    
    private func addRecenterButton() {
        recenterButton = RecenterButton()
        recenterButton!.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(recenterButton!)
        view.addConstraint(recenterButton!.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 30))
        view.addConstraint(recenterButton!.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -60))
        recenterButton!.addTarget(self, action: #selector(recenterCamera), for: .touchUpInside)
        
        recenterButton?.alpha = 0
    }
    
    private func addSignpostView() {
        signpost = DirectionSignpostContainer()
        signpost?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signpost!)
        view.addConstraint(signpost!.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0))
        signpostTop = signpost!.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        view.addConstraint(signpostTop!)
        
        updateLayout()
    }
    
    private func updateLayout() {
        guard let signpost = signpost else {
            return
        }
        
        if let width = signpostWidth {
            view.removeConstraint(width)
        }
        
        var multiplier: CGFloat = 1.0
        var cornerRadius: CGFloat = 0
        var topOffset: CGFloat = 0
        
        if OrientationUtils.isLandscape() {
            multiplier = 0.4
            cornerRadius = 16
            topOffset = 5
        }
        
        signpost.layer.cornerRadius = cornerRadius
        signpostWidth = signpost.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: 0)
        view.addConstraint(signpostWidth!)
        
        signpostTop!.constant = topOffset
    }
    
    @objc private func recenterCamera () {
        mapView?.cameraMovementMode = .followGpsPositionWithAutozoom
        mapView?.cameraRotationMode = .vehicle
        UIView.animate(withDuration: 0.2) {
            self.recenterButton?.alpha = 0
        }
    }
}

// MARK: -SYMapViewDelegate
extension OnlineNaviSampleViewController : SYMapViewDelegate {
    func mapView(_ mapView: SYMapView, didChangeCameraMovementMode mode: SYCameraMovement) {
        if let recenter = recenterButton {
            switch mode {
                case .followGpsPosition, .followGpsPositionWithAutozoom:
                    recenter.alpha = 0
                break
            case .free:
                UIView.animate(withDuration: 0.2, animations: {
                    recenter.alpha = 1
                })
                
                self.mapView?.cameraRotationMode = .free
            }
        }
    }
}

// MARK: -SYRoutingDelegate
extension OnlineNaviSampleViewController : SYRoutingDelegate {
    func routing(_ routing: SYRouting, didComputePrimaryRoute route: SYRoute?) {
        if let route = route {
            navitateWithRoute(route: route)
            if SYPositioning.shared().lastKnownLocation == nil {
                mapView?.cameraMovementMode = .free
                mapView?.setViewBoundingBox(route.box, with: UIEdgeInsets.init(top: 0.2, left: 0.2, bottom: 0.2, right: 0.2), duration: 1.0, curve: .decelerate, completion: nil)
            }
        }
    }
    
    func routing(_ routing: SYRouting, didFinishRouteRecompute route: SYRoute) {
        navitateWithRoute(route: route)
    }
    
    func routing(_ routing: SYRouting, computingFailedWithError error: SYRoutingError) {
        showMessage(message: String.init(format: "%@ - %@", "routingFailed".localized(), error.localizedDescription()))
    }
    
    func routingDidStartRouteComputing(_ routing: SYRouting) {
        NSLog("Route compute started")
    }
    
    func routingDidStartRouteRecompute(_ routing: SYRouting) {
        NSLog("Route recompute started")
    }
}

// MARK: -SYPositioningDelegate
extension OnlineNaviSampleViewController : SYPositioningDelegate {
    func positioning(_ positioning: SYPositioning, didUpdate position: SYPosition) {
        if lastPosition == nil {
            mapView?.animate({
                self.mapView?.zoom = 16
                self.mapView?.tilt = 50
                self.mapView?.geoCenter = position.coordinate!
            }, withDuration: 1, curve: .accelerateDecelerate, completion: { (Uint, Bool) in
                self.mapView?.cameraMovementMode = .followGpsPositionWithAutozoom
                self.mapView?.cameraRotationMode = .vehicle
            })
        }

        lastPosition = position
    }
}

// MARK: -SYNavigationDelegate
extension OnlineNaviSampleViewController : SYNavigationDelegate {
    func navigation(_ navigation: SYNavigation, didUpdateDirection instruction: SYInstruction?) {
        signpost!.udpateDirections(instruction: instruction)
    }
    
    func navigation(_ navigation: SYNavigation, didUpdateSignpost signpostInfo: [SYSignpost]?) {
        signpost!.updateSignposts(signposts: signpostInfo)
    }
    
    func navigationManagerDidReachFinish(_ navigation: SYNavigation) {
        NSLog("Finish reached!")
        
        signpost!.updateSignposts(signposts: nil)
        signpost!.udpateDirections(instruction: nil)
        
        SYNavigation.shared().stop()
        mapView?.remove(mapRoute!)
        mapRoute = nil;
        routing = nil;
        
        showMessage(message: "finishReached".localized(), title: "", quit: true)
    }
}

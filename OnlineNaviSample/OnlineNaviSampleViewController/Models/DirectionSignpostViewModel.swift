import Foundation
import SygicMaps

public class DirectionSignpostViewModel {
    private static let followDistanceThreshold: UInt = 1000
    private static let minimumTunnelLength: UInt = 200
    private static let signpostDefaultBackground = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    
    public static let routeNumbersMaxCount = 3
    public static let pictogramsMaxCount = 3
    
    private let distanceUnits: DistanceUnits = .kilometers //  TODO: Dynamically recieve from settings
    private var directionsEmpty = true
    private var signpostEmpty = true
    public var maneuver = SYManeuver()
    public var distance = String()
    public var directionTitle = String()
    public var signpostTitle = String()
    public var exit = String()
    public var routeNumbers = [SYRouteNumberFormat]()
    public var pictograms = [String]()
    public var backgroundColor = signpostDefaultBackground
    public var textColor = UIColor.white
    public var mainDirectionSymbol = String()
    public var helperDirectionSymbol = String()
    public var waypointLetterSymbol = String()
    
    public init() {
    }
    
    public func isEmpty() -> Bool {
        return directionsEmpty && signpostEmpty
    }
    
    public func update(with signposts: [SYSignpost]?) {
        // we are using just first signpost for now
        guard let signposts = signposts, let signpost = signposts.first else {
            signpostEmpty = true
            clearSignpostInfo()
            return
        }
        
        signpostEmpty = false

        if let color = signpost.textColor {
            textColor = color
        }

        if let color = signpost.backgroundColor {
            backgroundColor = color
        }

        var titles = [String]()
        var routeNumbers = [SYRouteNumberFormat]()
        var exitNames = [String]()
        var pictograms = [String]()

        for element in signpost.elements {
            switch element.type {
            case .placeName, .streetName, .otherDestination:
                if let text = element.text {
                    titles.append(text)
                }
            case .routeNumber:
                if let format = element.numberFormat {
                    routeNumbers.append(format)
                }
            case .exitName, .exitNumber:
                if let exitName = element.text {
                    exitNames.append(exitName)
                }
            case .pictogram:
                pictograms.append(element.pictogram.toSymbol())
            case .lineBreak:
//                titles.append("\n")
                break
            }
        }

        exit = exitNames.joined(separator: " ")
        
        if !exit.isEmpty {
            signpostTitle = "\("Exit (FROM HIGHWAY)".localized()) \(exit)"
        } else if titles.count > 0 {
            signpostTitle = titles.joined(separator: ", ")
        }
        
        self.routeNumbers = Array(routeNumbers.prefix(DirectionSignpostViewModel.routeNumbersMaxCount))
        self.pictograms = Array(pictograms.prefix(DirectionSignpostViewModel.pictogramsMaxCount))
    }

    public func update(with instruction: SYInstruction?) {
        directionsEmpty = true
        guard let instruction = instruction else {
            
            clearDirectionInfo()
            return
        }
        
        guard let primaryManeuver = instruction.primaryManeuver, primaryManeuver.type != .none else {
            clearDirectionInfo()
            return
        }
        
        directionsEmpty = false

        var distanceInMeters = primaryManeuver.distanceToManeuver

        if let tunnelData = instruction.tunnelData, tunnelData.isInTunnel && tunnelData.remainingTunnelDistance > DirectionSignpostViewModel.minimumTunnelLength {
            distanceInMeters = tunnelData.remainingTunnelDistance
        }

        distance = formattedDistance(distanceInMeters)
        maneuver = primaryManeuver
        
        let symbols = maneuver.toSymbols()
        helperDirectionSymbol = symbols[0]
        mainDirectionSymbol = symbols[1]
        
        if symbols.count > 2 {
            waypointLetterSymbol = symbols[2]
        }
        
        if let roundaboutExit = roundaboutExitFrom(maneuver: primaryManeuver) {
            exit = roundaboutExit
            directionTitle = "\("Exit (FROM HIGHWAY)".localized()) \(roundaboutExit)"
        } else if let roadName = primaryManeuver.nextRoad?.roadName, !roadName.isEmpty && primaryManeuver.type != .follow && primaryManeuver.distanceToManeuver <= DirectionSignpostViewModel.followDistanceThreshold {
            directionTitle = roadName
        } else {
            directionTitle = "route.instructionsText.continueAlong".localized()
        }
    }

    private func clearSignpostInfo() {
        textColor = .white
        backgroundColor = DirectionSignpostViewModel.signpostDefaultBackground
        signpostTitle = ""
        pictograms = [String]()
        routeNumbers = [SYRouteNumberFormat]()
    }

    private func clearDirectionInfo() {
        distance = ""
        exit = ""
        directionTitle = ""
        maneuver = SYManeuver()
        mainDirectionSymbol = ""
        helperDirectionSymbol = ""
        waypointLetterSymbol = ""
    }

    private func roundaboutExitFrom(maneuver: SYManeuver) -> String? {
        guard let roundaboutManeuver = maneuver as? SYManeuverRoundabout, roundaboutManeuver.roundaboutExitIndex > 0 else { return nil }
        return "\(roundaboutManeuver.roundaboutExitIndex)"
    }

    private func formattedDistance(_ distance: SYDistance) -> String {
        let remainingDistance = distance.format(toShortUnits: true, andRound: true)
        // space between distance and units is unicode 0x200A - hair space
        return "\(remainingDistance.formattedDistance) \(remainingDistance.units)"
    }
}

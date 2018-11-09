public enum DistanceUnits {
    case kilometers
    case milesFeet
    case milesYards
    
    public var speedTitle: String {
        switch self {
        case .kilometers: return "km/h".localized()
        default: return "mph".localized()
        }
    }
}

public class GeneralFormatter {
    
    private static let kmToMile = 0.62137119
    private static let mileToKm = 1.609344
    
    public static func format(_ distance: Double, from fromUnit: DistanceUnits, to toUnit: DistanceUnits) -> Double {
        var constant = 1.0
        if fromUnit == .kilometers && (toUnit == .milesYards || toUnit == .milesFeet) {
            constant = kmToMile
        } else if (fromUnit == .milesYards || fromUnit == .milesFeet) && toUnit == .kilometers {
            constant = mileToKm
        }
        return distance * constant;
    }
}

public class FormattersUnits {
    public static var clockFormat: String = "HH:mm"
    public static var distanceUnits: DistanceUnits = .kilometers
}

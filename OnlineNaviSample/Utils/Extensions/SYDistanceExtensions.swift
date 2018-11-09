import SygicMaps

public extension SYDistance {
    
    public var yards: Double {
        return Double(self) * 10000.0 / 9144.0
    }
    
    public var feet: Double {
        return Double(self) * 328084.0 / 100000.0
    }
    
    public var kilometers: Double {
        return Double(self) / 1000
    }
    
    public var stringValue: String {
        let distanceWithUnits = self.format(toShortUnits: true, andRound: true)
        return "\(distanceWithUnits.formattedDistance) \(distanceWithUnits.units)"
    }
    
    public func round() -> SYDistance {
        let distance = self
        
        // od SDK pride niekedy pretecena hodnota RemainingDistance, zatial vyriesene takto
        var correctedDistance = Swift.min(distance, UInt(Int.max))
        
        if correctedDistance < 5 {
            return 0
        }
        
        if correctedDistance < 30 {
            correctedDistance += 2
            return correctedDistance - correctedDistance % 5
        }
        
        if correctedDistance < 250 {
            correctedDistance += 5
            return correctedDistance - correctedDistance % 10
        }
        
        if correctedDistance < 800 {
            correctedDistance += 25
            return correctedDistance - correctedDistance % 50
        }
        
        if correctedDistance < 10000 {
            correctedDistance += 50
            return correctedDistance - correctedDistance % 100
        }
        
        correctedDistance += 500
        return correctedDistance - correctedDistance % 1000
    }
    
    
    public func format(toShortUnits shortUnits: Bool, andRound round: Bool, usingOtherThenFormattersUnits units: DistanceUnits = FormattersUnits.distanceUnits) -> (formattedDistance: String, units: String) {
        switch units {
        case .kilometers:
            return format(intoKilometersAndRound: round, toShortUnits: shortUnits)
        case .milesFeet:
            return format(intoMilesFeetAndRound: round, toShortUnits: shortUnits)
        case .milesYards:
            return format(intoMilesYardsAndRound: round, toShortUnits: shortUnits)
        }
    }
    
    private func format(intoKilometersAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String) {
        
        var formattedDistance: String
        var units: String
        let distance = round ? self.round() : self
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? "m" : "meters".localized()
        }
        else if distance < 10000 {
            formattedDistance = String(format: "%.1f", Double(Int(distance.kilometers*10))/10.0)
            units = shortUnits ? "km" : "kilometers".localized()
        }
        else {
            formattedDistance = String(format: "%d", Int(distance.kilometers))
            units = shortUnits ? "km" : "kilometers".localized()
        }
        
        return (formattedDistance, units)
    }
    
    private func format(intoMilesFeetAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String)  {
        
        var formattedDistance: String
        var units: String
        let distance = round ? SYDistance(self.feet).round() : SYDistance(self.feet)
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? "ft".localized() : "feet".localized()
        }
        else if distance < 10 * 5280 {
            formattedDistance = String(format: "%.1f", Double(distance)/5280)
            units = shortUnits ? "mi".localized() : "miles".localized()
        }
        else {
            formattedDistance = String(format: "%.0f", Double(distance)/5280)
            units = shortUnits ? "mi".localized() : "miles".localized()
        }
        
        return (formattedDistance, units)
    }
    
    private func format(intoMilesYardsAndRound round: Bool, toShortUnits shortUnits: Bool) -> (formattedDistance: String, units: String) {
        
        var formattedDistance: String
        var units: String
        let distance = round ? SYDistance(self.yards).round() : SYDistance(self.yards)
        
        if distance < 1000 {
            formattedDistance = String(format: "%d", distance)
            units = shortUnits ? "yd".localized() : "yards".localized()
        }
        else if distance < 10*1760 {
            formattedDistance = String(format: "%.1f", Double(distance)/1760)
            units = shortUnits ? "mi".localized() : "miles".localized()
        }
        else {
            formattedDistance = String(format: "%.0f", Double(distance)/1760)
            units = shortUnits ? "mi".localized() : "miles".localized()
        }
        
        return (formattedDistance, units)
    }
    
}

import SygicMaps

public extension SYSignpostElementPictogramType {
    
    public func toSymbol() -> String {
        switch self {
        case .none:
            return ""
        case .airport:
            return SygicIcon.plane
        case .busStation:
            return SygicIcon.bus
        case .fair:
            return SygicIcon.carCarrier
        case .ferryConnection:
            return SygicIcon.boat
        case .firstAidPost:
            return SygicIcon.hospital
        case .harbour:
            return SygicIcon.harbor
        case .hospital:
            return SygicIcon.hospital
        case .hotelOrMotel:
            return SygicIcon.accomodation
        case .industrialArea:
            return SygicIcon.factory
        case .informationCenter:
            return SygicIcon.infoCenter
        case .parkingFacility:
            return SygicIcon.parking
        case .petrolStation:
            return SygicIcon.stationPetrol
        case .railwayStation:
            return SygicIcon.train
        case .restArea:
            return SygicIcon.restingArea
        case .restaurant:
            return SygicIcon.restaurant
        case .toilet:
            return SygicIcon.toilet
        }
    }
}

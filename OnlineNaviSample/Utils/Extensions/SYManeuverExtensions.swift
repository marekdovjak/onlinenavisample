import SygicMaps

public extension SYManeuver {
    @objc public func toSymbols() -> [String] {
        return type.toSymbols()
    }
}

public extension SYManeuverExit {
    override public func toSymbols() -> [String] {
        return exitType.toSymbols()
    }
}

public extension SYManeuverRoundabout {
    override public func toSymbols() -> [String] {
        let symbols = roundaboutType.toSymbols()
        //UI doesnt support displaying roundabout exit number inside direction now
//        symbols.append("\(self.roundaboutExitIndex)")
        return symbols
    }
}

public extension SYManeuverType {
    public func toSymbols() -> [String] {
        switch self {
            case .none:
                return []
            case .start:
                return ["", SygicIcon.directionPin]
            case .easyLeft:
                return [SygicIcon.directionL45Base, SygicIcon.directionL45]
            case .easyRight:
                return [SygicIcon.directionR45Base, SygicIcon.directionR45]
            case .end, .via:
                return [SygicIcon.pinPlace, SygicIcon.pinPlace]
            case .keepLeft:
                return [SygicIcon.directionYLBase, SygicIcon.directionYL]
            case .keepRight:
                return [SygicIcon.directionYRBase, SygicIcon.directionYR]
            case .left:
                return [SygicIcon.directionL90Base, SygicIcon.directionL90]
            case .outOfRoute:
                return ["", SygicIcon.directionR90]
            case .right:
                return [SygicIcon.directionR90Base, SygicIcon.directionR90]
            case .sharpLeft:
                return [SygicIcon.directionL135Base, SygicIcon.directionL135]
            case .sharpRight:
                return [SygicIcon.directionR135Base, SygicIcon.directionR135]
            case .straight, .follow:
                return ["", SygicIcon.directionStright]
            case .uTurnLeft:
                return ["", SygicIcon.directionL180]
            case .uTurnRight:
                return ["", SygicIcon.directionR180]
            case .ferry:
                return ["", SygicIcon.avoidFerry]
            case .stateBoundary:
                return ["", SygicIcon.roadClosure]
            case .motorway:
                return ["", SygicIcon.avoidHighways]
            case .tunnel:
                return [SygicIcon.directionTunnelBase, SygicIcon.directionTunnel]
            case .roundabout, .exit:
                return []
        }
    }
    
}

public extension SYRoundaboutType {
    
    public func toSymbols() -> [String] {
        switch self {
            case .SE:
                return [SygicIcon.directionRoundR45Base, SygicIcon.directionRoundR45]
            case .E:
                return [SygicIcon.directionRoundR90Base, SygicIcon.directionRoundR90]
            case .NE:
                return [SygicIcon.directionRoundR135Base, SygicIcon.directionRoundR135]
            case .N:
                return [SygicIcon.directionRoundR180Base, SygicIcon.directionRoundR180]
            case .NW:
                return [SygicIcon.directionRoundR225Base, SygicIcon.directionRoundR225]
            case .W:
                return [SygicIcon.directionRoundR270Base, SygicIcon.directionRoundR270]
            case .SW:
                return [SygicIcon.directionRoundR315Base, SygicIcon.directionRoundR315]
            case .S:
                return [SygicIcon.directionRoundR360Base, SygicIcon.directionRoundR360]
            case .leftSE:
                return [SygicIcon.directionRoundL45Base, SygicIcon.directionRoundL45]
            case .leftE:
                return [SygicIcon.directionRoundL90Base, SygicIcon.directionRoundL90]
            case .leftNE:
                return [SygicIcon.directionRoundL135Base, SygicIcon.directionRoundL135]
            case .leftN:
                return [SygicIcon.directionRoundL180Base, SygicIcon.directionRoundL180]
            case .leftNW:
                return [SygicIcon.directionRoundL225Base, SygicIcon.directionRoundL225]
            case .leftW:
                return [SygicIcon.directionRoundL270Base, SygicIcon.directionRoundL270]
            case .leftSW:
                return [SygicIcon.directionRoundL315Base, SygicIcon.directionRoundL315]
            case .leftS:
                return [SygicIcon.directionRoundL360Base, SygicIcon.directionRoundL360]
        }
    }
    
}

public extension SYExitType {
    
    public func toSymbols() -> [String] {
        switch self {
            case .left:
                return ["", SygicIcon.directionHighwayExitL]
            case .right:
                return ["", SygicIcon.directionHighwayExitR]
        }
    }
    
}

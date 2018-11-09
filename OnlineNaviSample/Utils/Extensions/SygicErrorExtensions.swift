import Foundation
import SygicMaps

extension SYContexInitResult {
    func localizedDescription() -> String {
        switch self {
        case .appKeyVerificationFailed:
            return "init.error.keyVerificationFailed".localized()
        case .invalidAppKey:
            return "init.error.invalidApi".localized()
        case .runtimeError:
            return "init.error.runtimeError".localized()
        case .success:
            return "init.error.success".localized()
        }
    }
}

extension SYRoutingError {
    func localizedDescription() -> String {
        switch self {
        case .unreachableTarget:
            return "compute.error.unreachableTarget".localized()
        case .wrongFromPoint:
            return "compute.error.wrongFromPoint".localized()
        case .unspecifiedFault:
            return "compute.error.unspecifiedFault".localized()
        case .discontinuousGraph:
            return "compute.error.discontinuousGraph".localized()
        case .userCanceled:
            return "compute.error.userCanceled".localized()
        case .lowMemory:
            return "compute.error.lowMemory".localized()
        case .roadsLimitReached:
            return "compute.error.roadsLimitReached".localized()
        case .frontEmpty:
            return "compute.error.frontEmpty".localized()
        case .initializationFailed:
            return "compute.error.initializationFailed".localized()
        case .pathReconstructFailed:
            return "compute.error.pathReconstructFailed".localized()
        case .userRouteRemoved:
            return "compute.error.userRouteRemoved".localized()
        case .pathConstructFailed:
            return "compute.error.pathConstructFailed".localized()
        case .pathNotFound:
            return "compute.error.pathNotFound".localized()
        case .backwardFrontEmpty:
            return "compute.error.backwardFrontEmpty".localized()
        case .invalidSelection:
            return "compute.error.invalidSelection".localized()
        case .alternativeRejected:
            return "compute.error.alternativeRejected".localized()
        case .nullHell:
            return "compute.error.nullHell".localized()
        case .onlineServiceError:
            return "compute.error.onlineServiceError".localized()
        case .onlineServiceNotAvailable:
            return "compute.error.connection.onlineServiceNotAvailable".localized()
        case .onlineServiceWrongResponse:
            return "compute.error.onlineServiceWrongResponse".localized()
        case .onlineServiceTimeout:
            return "compute.error.onlineServiceTimeout".localized()
        case .fromAndToPointsTooClose:
            return "compute.error.fromAndToPointsTooClose".localized()
        case .noComputeCanBeCalled:
            return "compute.error.noComputeCanBeCalled".localized()
        case .couldNotRetrieveSavedRoute:
            return "compute.error.couldNotRetrieveSavedRoute".localized()
        case .mapNotAvailable:
            return "compute.error.mapNotAvailable".localized()
        }
    }

}

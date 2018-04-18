import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Configure StageTimeEvent Controller
    let stageTimeController = StageTimeEventsController()
    try router.register(collection: stageTimeController)
}

import Vapor

// Controllers basic CRUD operations on StageTime class
final class StageTimeEventsController {

    //Saves a decoded `StageTimeEvent` to database
    func create(_ req: Request) throws -> Future<StageTimeEvent> {
        return try req.content.decode(StageTimeEvent.self).flatMap(to: StageTimeEvent.self) { event in
            return event.save(on: req)
        }
    }

    //Return all `StageTimeEvent`s
    func index(_ req: Request) throws -> Future<[StageTimeEvent]> {
        return StageTimeEvent.query(on: req).all()
    }

    //Deletes a parametized `StageTimeEvent`
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameter(StageTimeEvent.self).flatMap(to: Void.self) { event in
            return event.delete(on: req)
        }.transform(to: .ok)
    }
}

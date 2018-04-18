import Vapor

// Controllers basic CRUD operations on StageTime class
// Used to handle

final class StageTimeEventsController: RouteCollection {

    func boot(router: Router) throws {
        let stageTimeRoute = router.grouped("api", "stagetime")
        stageTimeRoute.get(use: getAll)
        stageTimeRoute.post(use: create)
        stageTimeRoute.delete(StageTimeEvent.parameter, use: delete)
        stageTimeRoute.get(StageTimeEvent.parameter, use: getEvent)
        stageTimeRoute.put(StageTimeEvent.parameter, use: updateEvent)
    }

    //Saves a decoded `StageTimeEvent` to database
    func create(_ req: Request) throws -> Future<StageTimeEvent> {
        return try req.content.decode(StageTimeEvent.self).flatMap(to: StageTimeEvent.self) { event in
            return event.save(on: req)
        }
    }

    //Return all `StageTimeEvent`s
    func getAll(_ req: Request) throws -> Future<[StageTimeEvent]> {
        return StageTimeEvent.query(on: req).all()
    }

    //Deletes a parametized `StageTimeEvent`
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameter(StageTimeEvent.self).flatMap(to: HTTPStatus.self) { event in
            return event.delete(on: req).transform(to: .noContent)
        }
    }

    func getEvent(_ req: Request) throws -> Future<StageTimeEvent> {
        return try req.parameter(StageTimeEvent.self)
    }

    func updateEvent(_ req: Request) throws -> Future<StageTimeEvent> {
        return try flatMap(to: StageTimeEvent.self, req.parameter(StageTimeEvent.self), req.content.decode(StageTimeEvent.self), { event, updatedEvent in
            event.title = updatedEvent.title
            event.stageTime = updatedEvent.stageTime
            event.type = updatedEvent.type
            return event.save(on: req)
        })
    }
}

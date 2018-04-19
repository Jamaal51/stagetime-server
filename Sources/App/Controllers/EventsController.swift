import Vapor
import Fluent

// Controllers basic CRUD operations on StageTime class
// Used to handle

final class EventsController: RouteCollection {

    func boot(router: Router) throws {
        let stageTimeRoute = router.grouped("api", "events")
        stageTimeRoute.get(use: getAll)
        stageTimeRoute.post(use: create)
        stageTimeRoute.delete(Event.parameter, use: delete)
        stageTimeRoute.get(Event.parameter, use: getEvent)
        stageTimeRoute.put(Event.parameter, use: updateEvent)
        stageTimeRoute.get(Event.parameter, "host", use: getHost)
        stageTimeRoute.get("search", use: search)
    }

    func create(_ req: Request) throws -> Future<Event> {
        return try req.content.decode(Event.self).flatMap(to: Event.self) { event in
            return event.save(on: req)
        }
    }

    func getAll(_ req: Request) throws -> Future<[Event]> {
        return Event.query(on: req).all()
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameter(Event.self).flatMap(to: HTTPStatus.self) { event in
            return event.delete(on: req).transform(to: .noContent)
        }
    }

    func getEvent(_ req: Request) throws -> Future<Event> {
        return try req.parameter(Event.self)
    }

    func updateEvent(_ req: Request) throws -> Future<Event> {
        return try flatMap(to: Event.self, req.parameter(Event.self), req.content.decode(Event.self), { event, updatedEvent in
            event.title = updatedEvent.title
            event.stageTime = updatedEvent.stageTime
            event.type = updatedEvent.type
            return event.save(on: req)
        })
    }

    func getHost(_ req: Request) throws -> Future<User> {
        return try req.parameter(Event.self).flatMap(to: User.self) { event in
            return try event.host.get(on: req)
        }
    }

    func search(_ req: Request) throws -> Future<[Event]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest, reason: "Missing search term in request")
        }
        return try Event.query(on: req).group(.or) { or in
            try or.filter(\.title == searchTerm)
            try or.filter(\.type == searchTerm)
        }.all()
    }
}

import Vapor

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRoute = router.grouped("api", "users")
        userRoute.post(use: createUser)
        userRoute.get(User.parameter, use: getUser)
        userRoute.get(User.parameter, "allEventsAsHost", use: getEventsAsHost)
    }

    func createUser(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            user.save(on: req)
        }
    }

    func getUser(_ req: Request) throws -> Future<User> {
        return try req.parameter(User.self)
    }

    func getEventsAsHost(_ req: Request) throws -> Future<[Event]> {
        return try req.parameter(User.self).flatMap(to: [Event].self) { user in
            return try user.eventsHosted.query(on: req).all()
        }
    }
}

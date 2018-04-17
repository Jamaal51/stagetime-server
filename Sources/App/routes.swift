import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.get("hello", "vapor") { req in
        return "Hello Vapor"
    }

    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameter(String.self)
        return "Hello \(name)"
    }

    router.post(InfoData.self, at: "info") { req, response -> InfoResponse in
        let name = response.name
        print("Request: \(req)")
        return InfoResponse(request: response)
    }

    router.get("date") { req -> String in
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return "Today's date is \(dateFormatter.string(from: today))"
    }

    router.get("counter", Int.parameter) { req -> Int in
        let count = try req.parameter(Int.self)
        return count
    }

    router.post(UserInfoData.self, at:"user-info") { req, userInfo -> String in
        return "Hello I am \(userInfo.name), I am \(userInfo.age)"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct UserInfoData: Content {
    let name: String
    let age: Int
}

import FluentMySQL
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    /// Adding Services for Vapor are for adding in functionality

    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    var databases = DatabaseConfig()
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 8080, username: "stagetime-server", password: "stagetime", database: "vapor")
    let database = MySQLDatabase(config: mysqlConfig)
    /// Register the configured SQLite database to the database config.
    databases.add(database: database, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Event.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
}

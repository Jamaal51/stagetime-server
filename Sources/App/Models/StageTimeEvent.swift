//
//  StageTime.swift
//  App
//
//  Created by Jamaal Sedayao on 4/17/18.
//

import FluentSQLite
import Vapor

final class StageTimeEvent: SQLiteModel {
    var id: Int?
    var title: String
    var type: String
    var stageTime: Int

    init(id: Int? = nil, title: String, type: String, stageTime: Int) {
        self.id = id
        self.title = title
        self.type = type
        self.stageTime = stageTime
    }
}

/// Allows `StageTime` to be used as a dynamic migration.
extension StageTimeEvent: Migration { }

/// Allows `StageTime` to be encoded to and decoded from HTTP messages.
extension StageTimeEvent: Content { }

/// Allows `StageTime` to be used as a dynamic parameter in route definitions.
extension StageTimeEvent: Parameter { }

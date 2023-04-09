//
//  User.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 09.11.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String
}

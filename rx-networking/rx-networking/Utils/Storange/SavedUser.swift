//
//  SavedUser.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class SavedUser: Object {
    dynamic var login: String = ""
    dynamic var html_url: String = ""
    dynamic var type: String = ""
}

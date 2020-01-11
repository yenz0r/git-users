//
//  GitHubUser.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
    let type: String
}

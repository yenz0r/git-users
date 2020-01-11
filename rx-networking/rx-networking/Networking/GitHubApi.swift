//
//  GitHubApi.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import Moya

enum GitHubApi {
    case users
}

extension GitHubApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .users: return "/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .users: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .users:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

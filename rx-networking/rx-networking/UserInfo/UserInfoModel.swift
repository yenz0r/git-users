//
//  UserInfoModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation

class UserInfoModel {
    let selectedUser: GitHubUser

    init(for user: GitHubUser) {
        self.selectedUser = user
    }
}

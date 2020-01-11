//
//  UsersListModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class UsersListModel {

    private let provider = MoyaProvider<GitHubApi>()

    func fetchUsers() -> Observable<[GitHubUser]> {
        self.provider
            .rx
            .request(.users)
            .filterSuccessfulStatusCodes()
            .map([GitHubUser].self)
            .asObservable()
    }
}

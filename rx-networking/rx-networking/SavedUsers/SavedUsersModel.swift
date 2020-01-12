//
//  SavedUsersModel.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SavedUsersModel {
    private let usersRepository: UsersRepository

    init() {
        self.usersRepository = UsersRepository()
    }

    func fetchUsers() -> Observable<[SavedUser]> {
        return self.usersRepository.fetchSavedUsers()
    }
}

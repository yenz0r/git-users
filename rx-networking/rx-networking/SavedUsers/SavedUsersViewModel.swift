//
//  SavedUsersViewModel.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SavedUsersViewModel {
    struct Input {

    }

    struct Output {
        let users: Driver<[SavedUser]>
    }

    let output: Output
    let input: Input
    var model: SavedUsersModel

    init(model: SavedUsersModel) {
        self.model = model
        let usersObservable = self.model.fetchUsers()

        self.output = Output(users: usersObservable.asDriver(onErrorJustReturn: []))
        self.input = Input()
    }
}

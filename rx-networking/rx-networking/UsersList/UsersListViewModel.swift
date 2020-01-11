//
//  UsersListViewModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UsersListViewModel {
    struct Output {
        let users: Driver<[GitHubUser]>
    }

    struct Input {
        let selectTrigger: AnyObserver<IndexPath>
    }

    let output: Output
    let input: Input

    private let model: UsersListModel
    private let router: UsersListRouter

    private let disposeBag = DisposeBag()

    init(model: UsersListModel, router: UsersListRouter) {
        self.model = model
        self.router = router

        let users = self.model.fetchUsers().share(replay: 1)

        let selectSubject = PublishSubject<IndexPath>()
        selectSubject
            .asObserver()
            .withLatestFrom(users, resultSelector: { indexPath, items -> GitHubUser? in
                guard items.indices.contains(indexPath.row) else { return nil }
                return items[indexPath.row]
            })
            .do(onNext: {
                guard let user = $0 else { return }
                print(user)
                router.showUserInfo(for: user)
            })
            .asDriver(onErrorJustReturn: nil)
            .drive()
            .disposed(by: self.disposeBag)

        self.input = Input(selectTrigger: selectSubject.asObserver())
        self.output = Output(users: users.asDriver(onErrorJustReturn: []))
    }
}

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
        let savedItemTrigger: AnyObserver<Void>
        let searchTrigger: AnyObserver<String>
    }

    let output: Output
    let input: Input

    private let model: UsersListModel
    private let router: UsersListRouter

    private let disposeBag = DisposeBag()

    init(model: UsersListModel, router: UsersListRouter) {
        self.model = model
        self.router = router

        let users = model.fetchUsers().share(replay: 1)

        let searchSubject = PublishSubject<String>()
        let search = searchSubject
            .startWith("")
            .distinctUntilChanged()
            .throttle(1.0, scheduler: MainScheduler.instance)

        let filteredItems = Observable
        .combineLatest(users, search) { items, filter in
            items.filter { $0.login.lowercased().hasPrefix(filter.lowercased()) }
        }
        .asDriver(onErrorJustReturn: [])

        let selectSubject = PublishSubject<IndexPath>()
        selectSubject
            .asObserver()
            .withLatestFrom(users, resultSelector: { indexPath, items -> GitHubUser? in
                guard items.indices.contains(indexPath.row) else { return nil }
                return items[indexPath.row]
            })
            .do(onNext: {
                guard let user = $0 else { return }
                router.showUserInfo(for: user)
            })
            .asDriver(onErrorJustReturn: nil)
            .drive()
            .disposed(by: self.disposeBag)

        let savedItemSubject = PublishSubject<Void>()
        savedItemSubject
            .asObserver()
            .do(onNext: { router.showSavedUsers() })
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: self.disposeBag)

        self.input = Input(
            selectTrigger: selectSubject.asObserver(),
            savedItemTrigger: savedItemSubject.asObserver(),
            searchTrigger: searchSubject.asObserver()
        )
        self.output = Output(users: filteredItems.asDriver(onErrorJustReturn: []))
    }
}

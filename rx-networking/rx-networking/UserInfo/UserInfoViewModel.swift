//
//  UserInfoViewModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

class UserInfoViewModel {
    struct Input {
        let linkTapTrigger: AnyObserver<Void>
        let saveItemTapTrigger: AnyObserver<Void>
    }

    struct Output {
        let user: Driver<GitHubUser?>
        let avatarImage: Driver<UIImage>
    }

    private let model: UserInfoModel
    private let router: UserInfoRouter

    private let disposeBag = DisposeBag()

    let input: Input
    let output: Output

    init(model: UserInfoModel, router: UserInfoRouter) {
        self.model = model
        self.router = router

        let userSubject = BehaviorSubject<GitHubUser?>(value: self.model.selectedUser)

        let linkTapSubjet = PublishSubject<Void>()
        linkTapSubjet
            .asObserver()
            .do(onNext: {
            router.showHtmlProfile(for: model.selectedUser.html_url)
        }).asDriver(onErrorJustReturn: ()).drive().disposed(by: self.disposeBag)

        let imageSubject = model.fetchImage(for: self.model.selectedUser.avatar_url)

        let saveItemSubject = PublishSubject<Void>()
        saveItemSubject
            .asObserver()
            .do(onNext: { model.saveUser(model.selectedUser) })
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: self.disposeBag)

        self.input = Input(
            linkTapTrigger: linkTapSubjet.asObserver(),
            saveItemTapTrigger: saveItemSubject.asObserver()
        )
        self.output = Output(
            user: userSubject.asDriver(onErrorJustReturn: nil),
            avatarImage: imageSubject.asDriver(onErrorJustReturn: UIImage())
        )
    }

}

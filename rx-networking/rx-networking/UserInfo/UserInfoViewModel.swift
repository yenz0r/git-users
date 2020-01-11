//
//  UserInfoViewModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoViewModel {
    struct Input {
        let linkTapTrigger: AnyObserver<Void>
    }

    struct Output {
        let user: Driver<GitHubUser?>
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
        let userHtmlPath = self.model.selectedUser.html_url
        linkTapSubjet.asObserver().do(onNext: {
            guard let url = URL(string: userHtmlPath)  else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }).asDriver(onErrorJustReturn: ()).drive().disposed(by: self.disposeBag)

        self.input = Input(linkTapTrigger: linkTapSubjet.asObserver())
        self.output = Output(user: userSubject.asDriver(onErrorJustReturn: nil))
    }

}

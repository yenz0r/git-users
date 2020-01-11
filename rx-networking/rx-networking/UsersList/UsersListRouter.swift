//
//  UsersListRouter.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import UIKit

class UsersListRouter {
    private var view: UIViewController?

    init(view: UIViewController) {
        self.view = view
    }

    func showUserInfo(for user: GitHubUser) {
        guard let parentView = self.view else { return }

        let view = UserInfoView()
        let model = UserInfoModel(for: user)
        let router = UserInfoRouter(view: view)
        let viewModel = UserInfoViewModel(model: model, router: router)

        view.viewModel = viewModel

        parentView.navigationController?.pushViewController(view, animated: true)
    }
}

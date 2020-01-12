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

    func showSavedUsers() {
        guard let parentView = self.view else { return }

        let savedUsersView = SavedUsersView()
        let savedUsersModel = SavedUsersModel()
        let savedUsersViewModel = SavedUsersViewModel(model: savedUsersModel)

        savedUsersView.viewModel = savedUsersViewModel

        parentView.navigationController?.pushViewController(savedUsersView, animated: true)
    }

    func showUserInfo(for user: GitHubUser) {
        guard let parentView = self.view else { return }

        let userInfoView = UserInfoView()
        let userInfoModel = UserInfoModel(for: user)
        let userInfoRouter = UserInfoRouter(view: userInfoView)
        let userInfoViewModel = UserInfoViewModel(model: userInfoModel, router: userInfoRouter)

        userInfoView.viewModel = userInfoViewModel

        parentView.navigationController?.pushViewController(userInfoView, animated: true)
    }
}

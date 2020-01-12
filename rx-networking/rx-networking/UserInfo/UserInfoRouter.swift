//
//  UserInfoRouter.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import UIKit

class UserInfoRouter {
    private weak var view: UIViewController?

    init(view: UIViewController) {
        self.view = view
    }

    func showHtmlProfile(for path: String) {
        guard let url = URL(string: path)  else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

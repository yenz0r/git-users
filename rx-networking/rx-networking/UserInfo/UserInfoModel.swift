//
//  UserInfoModel.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import Nuke
import RxSwift

class UserInfoModel {
    private let user: GitHubUser
    private let usersRepository: UsersRepository

    var selectedUser: GitHubUser {
        return self.user
    }

    init(for user: GitHubUser) {
        self.user = user
        self.usersRepository = UsersRepository()
    }

    func fetchImage(for path: String) -> ReplaySubject<UIImage> {
        let imageSubject = ReplaySubject<UIImage>.create(bufferSize: 1)
        if let url = URL(string: path) {
            let imageRequest = ImageRequest(url: url)
            if let cachedImage = ImageCache.shared[imageRequest] {
                imageSubject.asObserver().onNext(cachedImage)
            } else {
                ImagePipeline.shared.loadImage(with: imageRequest) { response in
                    let image = try! response.get().image
                    ImageCache.shared[imageRequest] = image
                    imageSubject.asObserver().onNext(image)
                }
            }
        }
        return imageSubject
    }

    func saveUser(_ user: GitHubUser) {
        self.usersRepository.saveUser(from: user)
    }
}

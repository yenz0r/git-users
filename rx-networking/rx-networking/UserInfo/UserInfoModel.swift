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
    let selectedUser: GitHubUser

    init(for user: GitHubUser) {
        self.selectedUser = user
    }

    func fetchImage(for path: String) -> PublishSubject<UIImage> {
        let imageSubject = PublishSubject<UIImage>()
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
}

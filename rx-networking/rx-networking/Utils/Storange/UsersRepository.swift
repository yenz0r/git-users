//
//  UsersRepository.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

class UsersRepository {
    private let realm: Realm

    init() {
        self.realm = try! Realm()
    }

    func fetchSavedUsers() -> Observable<[SavedUser]> {
        let resultUsers = self.realm.objects(SavedUser.self)
        let fetchedUsers = Observable.collection(from: resultUsers).map { $0.toArray() }
        return fetchedUsers
    }

    func saveUser(from user: GitHubUser) {
        let userToSave = SavedUser()
        userToSave.html_url = user.html_url
        userToSave.login = user.login
        userToSave.type = user.type
        do {
            try self.realm.write {
                self.realm.add(userToSave)
            }
        } catch {
            print("save err")
        }
    }
}

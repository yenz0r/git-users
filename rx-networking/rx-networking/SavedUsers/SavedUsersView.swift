//
//  SavedUsersView.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SavedUsersView: UIViewController {
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: SavedUsersViewModel!

    override func loadView() {
        self.view = UIView()

        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Saved Users"

        self.tableView.register(SavedUserCell.self, forCellReuseIdentifier: "savedUserCell")
        self.tableView.tableFooterView = UIView()

        self.bindViewModel()
    }

    private func bindViewModel() {
        self.viewModel
            .output
            .users
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "savedUserCell", cellType: SavedUserCell.self)) { _, user, cell in
                cell.login = user.login
                cell.link = user.html_url
                cell.type = user.type
            }.disposed(by: self.disposeBag)
    }
}

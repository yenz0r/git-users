//
//  UsersListView.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit

class UsersListView: UIViewController {
    private var tableView: UITableView!
    private var savedBarItem: UIBarButtonItem!

    private let search = BehaviorRelay(value: "")

    var viewModel: UsersListViewModel!

    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = UIView()

        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.savedBarItem = UIBarButtonItem(title: "Saved", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.savedBarItem

        let search = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Users list"

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.bindViewModel()
    }

    private func bindViewModel() {
        self.viewModel
            .output
            .users
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                cell.textLabel?.text = item.login
            }.disposed(by: self.disposeBag)

        self.tableView
            .rx
            .itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .bind(to: self.viewModel.input.selectTrigger)
            .disposed(by: self.disposeBag)

        self.savedBarItem
            .rx
            .tap
            .bind(to: self.viewModel.input.savedItemTrigger)
            .disposed(by: self.disposeBag)

        self.search
            .bind(to: viewModel.input.searchTrigger)
            .disposed(by: disposeBag)
    }
}

extension UsersListView: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        self.search.accept(searchController.searchBar.text ?? "")
    }
}

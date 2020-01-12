//
//  UserInfoView.swift
//  rx-networking
//
//  Created by yenz0redd on 11.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

class UserInfoView: UIViewController {
    private var loginLabel: UILabel!
    private var avatarImageView: UIImageView!
    private var avatarContainerView: UIView!
    private var typeLabel: UILabel!
    private var linkLabel: UILabel!

    private var saveBarItem: UIBarButtonItem!

    private let linkTapSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    var viewModel: UserInfoViewModel!

    override func loadView() {
        self.view = UIView()

        self.loginLabel = UILabel()
        self.view.addSubview(self.loginLabel)
        self.loginLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview()
        }

        self.typeLabel = UILabel()
        self.view.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.loginLabel.snp.bottom).offset(40)
        }

        self.linkLabel = UILabel()
        self.view.addSubview(self.linkLabel)
        self.linkLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        self.avatarContainerView = UIView()
        self.view.addSubview(self.avatarContainerView)
        self.avatarContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.typeLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.linkLabel.snp.top).offset(-10)
        }

        self.avatarImageView = UIImageView()
        self.avatarContainerView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.avatarImageView.snp.width)
        }

        self.saveBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.saveBarItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "User info"

        self.loginLabel.font = UIFont(name: "Avenir-Roman", size: 30)
        self.loginLabel.textAlignment = .center

        self.typeLabel.textAlignment = .center

        self.avatarImageView.contentMode = .scaleAspectFit

        self.linkLabel.textColor = .blue
        self.linkLabel.isUserInteractionEnabled = true
        self.linkLabel.textAlignment = .center
        let linkTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        self.linkLabel.addGestureRecognizer(linkTapGesture)

        self.bindViewModel()
    }

    @objc private func handleLinkTap() {
        self.linkTapSubject.onNext(())
    }

    private func bindViewModel() {
        self.viewModel.output.user.asObservable().bind { [weak self] user -> Void in
            guard let user = user, let strongSelf = self else { return }
            strongSelf.loginLabel.text = user.login
            strongSelf.typeLabel.text = user.type
            strongSelf.linkLabel.text = user.html_url
        }.disposed(by: self.disposeBag)

        self.viewModel.output.avatarImage.asObservable().bind { [weak self] image -> Void in
            self?.avatarImageView.image = image
        }.disposed(by: self.disposeBag)

        self.linkTapSubject
            .bind(to: self.viewModel.input.linkTapTrigger)
            .disposed(by: self.disposeBag)

        self.saveBarItem
            .rx
            .tap
            .bind(to: self.viewModel.input.saveItemTapTrigger)
            .disposed(by: self.disposeBag)
    }
}

//
//  SavedUserCell.swift
//  rx-networking
//
//  Created by yenz0redd on 12.01.2020.
//  Copyright © 2020 yenz0redd. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SavedUserCell: UITableViewCell {
    var login: String? {
        didSet {
            self.setupText(self.login, in: self.loginLabel)
        }
    }

    var link: String? {
        didSet {
            self.setupText(self.link, in: self.linkLabel)
        }
    }

    var type: String? {
        didSet {
            self.setupText(self.type, in: self.typeLabel)
        }
    }

    private var loginLabel: UILabel!
    private var linkLabel: UILabel!
    private var typeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.loginLabel = UILabel()
        self.contentView.addSubview(self.loginLabel)
        self.loginLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.width.height.equalToSuperview().dividedBy(2)
        }
        self.loginLabel.textAlignment = .center

        self.typeLabel = UILabel()
        self.contentView.addSubview(self.typeLabel)
        self.typeLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(10)
            make.width.height.equalTo(self.loginLabel)
        }
        self.typeLabel.textAlignment = .center

        self.linkLabel = UILabel()
        self.contentView.addSubview(self.linkLabel)
        self.linkLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.top.equalTo(self.loginLabel.snp.bottom).offset(10)
        }
        self.linkLabel.textColor = .blue
        self.linkLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.login = nil
        self.link = nil
        self.type = nil
    }

    private func setupText(_ text: String?, in label: UILabel) {
        if let text = text {
            label.text = text
        } else {
            label.text = ""
        }
    }
}

//
//  UserInfoTableViewCell.swift
//  GitHubManager
//
//  Created by User on 06.12.2022.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
       var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        var label = UILabel()
         label.numberOfLines = 0
         return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "add")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var config = UIBackgroundConfiguration.listPlainCell()
        config.strokeColor = .red
        config.strokeWidth = 2
        config.cornerRadius = 90
        config.backgroundInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        backgroundConfiguration = config
        contentView.clipsToBounds = true
//        contentView.layer.masksToBounds = true
        layout()
    }
    
    func layout() {
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(avatarImageView.snp.height).multipliedBy(1.0 / 1.0)
        }
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  RepositoryTableViewCell.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue-Plain", size: 14)

        return label
    }()
    
    lazy var lastDateLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont(name:"HelveticaNeue-Plain", size: 14)
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var backGroundConfig = UIBackgroundConfiguration.listPlainCell()
        backGroundConfig.cornerRadius = 15
        backGroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        backGroundConfig.strokeColor = .systemBlue
        backGroundConfig.strokeWidth = 2
//        backGroundConfig.backgroundColor = .gray
        backgroundConfiguration = backGroundConfig
        layout()
    }

    
    private func layout() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(24)
        }
        
        contentView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(24)
        }
        
        contentView.addSubview(lastDateLabel)
        lastDateLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(24)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(24)
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

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
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    lazy var lastDateLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    private func layout() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(lastDateLabel)
        lastDateLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(10)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(10)
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

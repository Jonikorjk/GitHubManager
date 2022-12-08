//
//  AssosiateTableViewCell.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import UIKit

class AssosiateTableViewCell: UITableViewCell {

    var keyLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    var valueLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private func layout() {
        contentView.addSubview(keyLabel)
        keyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(keyLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
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

//
//  DataCell.swift
//  ExCombineInputOutput
//
//  Created by 준우의 MacBook 16 on 4/27/24.
//

import UIKit

final class DataCell: UITableViewCell {
    static let identifier: String = "DataCell"

    var title = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            title.widthAnchor.constraint(equalToConstant: 200),
            title.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

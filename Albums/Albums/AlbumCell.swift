//
//  AlbumCell.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import UIKit

final class AlbumCell: UICollectionViewCell {
    
    static var id: String {
        return String(describing: self)
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, at: 0)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 2
        view.minimumScaleFactor = 0.3
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 13),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26)
        ])
        return view
    }()
    
    lazy var artistLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        view.minimumScaleFactor = 0.3
        view.textColor = #colorLiteral(red: 0.7608423829, green: 0.7608423829, blue: 0.7608423829, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 14)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 13),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width / 7
    }
}

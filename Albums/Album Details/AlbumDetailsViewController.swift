//
//  AlbumDetailsViewController.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation
import UIKit

final class AlbumDetailsViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    let album: AlbumViewModel
    
    init(album: AlbumViewModel, coordinator: Coordinator) {
        self.album = album
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.5)
        button.tintColor = #colorLiteral(red: 0.06666666667, green: 0.07058823529, blue: 0.1490196078, alpha: 1)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32),
            button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        return button
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.textColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.textColor = #colorLiteral(red: 0.06666666667, green: 0.07058823529, blue: 0.1490196078, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.3
        label.textColor = #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.visitButton.topAnchor, constant: -24)
        ])

        return label
    }()
    
    lazy var visitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(visitAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4901960784, blue: 1, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 45),
            button.widthAnchor.constraint(equalToConstant: 160),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ])
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        
        //labels + tags stack view
        let topStackView = UIStackView(arrangedSubviews: [artistLabel, titleLabel])
        topStackView.distribution = .fill
        topStackView.axis = .vertical
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16),
            topStackView.topAnchor.constraint(equalTo: self.headerImageView.bottomAnchor, constant: 34),
            topStackView.bottomAnchor.constraint(equalTo: self.copyrightLabel.topAnchor, constant: -16)
        ])
        
        let tagsContainerView = UIView()
        tagsContainerView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.addArrangedSubview(tagsContainerView)
        view.layoutIfNeeded()
        
        let genresView = AlbumGenresTagsView(frame: tagsContainerView.bounds)
        tagsContainerView.addSubview(genresView)
        
        album.setCoverImageFor(headerImageView)
        artistLabel.text = album.artist
        titleLabel.text = album.title
        album.genere.forEach { genre in
            genresView.addTag(text: genre.name)
        }
        copyrightLabel.text = "Released May 20, 2022\nCopyright 2022 Apple Inc. All rights reserved."
        visitButton.setTitle(NSLocalizedString("Visit The Album", comment: ""), for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func backAction() {
        coordinator?.showAlbums()
    }
    
    @objc private func visitAction() {
        guard let url = album.albumURL, UIApplication.shared.canOpenURL(url) else {
            presentError(error: "Sorry URL for this album is broken", retryBlock: visitAction)
            return
        }
        
        UIApplication.shared.open(url)
    }
}

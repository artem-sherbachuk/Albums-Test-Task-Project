//
//  ViewController.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import UIKit

final class AlbumsViewController: BaseViewController {

    lazy var collectionView: AlbumsCollectionView = {
        let collectionView = AlbumsCollectionView(frame: self.view.bounds)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.actionDelegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
        ])
        return collectionView
    }()
    
    var albums: [AlbumViewModel] = [] {
        didSet {
            collectionView.albums = albums
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Top 100 Albums", comment: "")
        view.backgroundColor = .systemBackground
        fetchAlbums()
    }
    
    private func fetchAlbums() {
        collectionView.showRefreshIndicator()
        
        coordinator?.repository.fetchAlbums(count: 10, successCompletion: populateAlbums(albums:), errorCompletion: { [weak self] error in
            guard let `self` = self else { return }
            self.handleError(error: error, retryBlock: self.fetchMoreAlbums)
        })
    }
    
    private func fetchMoreAlbums() {
        collectionView.showRefreshIndicator()
        
        coordinator?.repository.fetchMoreAlbums(successCompletion: populateAlbums(albums:),
                                                errorCompletion: { [weak self] error in
            guard let `self` = self else { return }
            self.handleError(error: error, retryBlock: self.fetchMoreAlbums)
        })
    }
    
    private func populateAlbums(albums: RealmResults<Album>) {
        collectionView.hideRefreshIndicator()
        self.albums = AlbumViewModel.createFrom(albums)
    }
    
    private func handleError(error: Error, retryBlock: @escaping () -> Void ) {
        collectionView.hideRefreshIndicator()
        presentError(error: error, retryBlock: retryBlock)
    }
}

extension AlbumsViewController: AlbumsCollectionViewDelegate {
    func didPullRefreshAction() {
        fetchAlbums()
    }
    
    func didSelectItemAt(_ indexPath: IndexPath) {
        let album = albums[indexPath.item]
        coordinator?.showAlbumDetails(album)
    }
    
    func didScrollToBottom() {
        fetchMoreAlbums()
    }
}

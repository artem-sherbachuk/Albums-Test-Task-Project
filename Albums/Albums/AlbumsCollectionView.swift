//
//  AlbumsCollectionView.swift
//  Albums
//
//  Created by Artem on 8/4/22.
//

import UIKit

protocol AlbumsCollectionViewDelegate: AnyObject {
    func didPullRefreshAction()
    func didSelectItemAt(_ indexPath: IndexPath)
    func didScrollToBottom()
}

final class AlbumsCollectionView: UICollectionView {
    
    weak var actionDelegate: AlbumsCollectionViewDelegate?
    
    lazy var refresh = UIRefreshControl()
    
    var albums: [AlbumViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    lazy var activity: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityView
    }()
    
    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        self.init(frame: frame, collectionViewLayout: layout)
        
        register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.id)
        delegate = self
        dataSource = self
        
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refresh.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        addSubview(refresh)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        actionDelegate?.didPullRefreshAction()
    }
    
    func showRefreshIndicator() {
        activity.startAnimating()
    }
    
    func hideRefreshIndicator() {
        activity.stopAnimating()
        refresh.endRefreshing()
    }
}


extension AlbumsCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = albums[indexPath.item]
        let cell: AlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.id, for: indexPath) as? AlbumCell ?? AlbumCell()
        cell.titleLabel.text = album.title
        cell.artistLabel.text = album.artist
        album.setCoverImageFor(cell.imageView)
        return cell
    }
}

extension AlbumsCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        actionDelegate?.didSelectItemAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isReachedBottom = indexPath.item == albums.count - 1
        
        if isReachedBottom {
            actionDelegate?.didScrollToBottom()
        }
    }
}

extension AlbumsCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: size, height: size)
    }
}

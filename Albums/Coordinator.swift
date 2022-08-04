//
//  Coordinator.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import UIKit

final class Coordinator {
    
    var navigationController: UINavigationController
    
    let repository: DBRepository

    init(window: UIWindow) {
        let navController = UINavigationController()
        navController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navController
        window.makeKeyAndVisible()
        navigationController = navController
        
        repository = DBRepository()
        
        start()
    }

    func start() {
        let vc = AlbumsViewController(coordinator: self)
        navigationController.viewControllers = [vc]
    }
    
    func showAlbums() {
        navigationController.popViewController(animated: true)
        navigationController.popToRootViewController(animated: false)
    }
    
    func showAlbumDetails(_ album: AlbumViewModel) {
        let vc = AlbumDetailsViewController(album: album, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}

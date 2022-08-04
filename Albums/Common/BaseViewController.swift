//
//  BaseViewController.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentError(error: Error, retryBlock: @escaping () -> Void) {
        
        let description = error.localizedDescription
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: description, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) { _ in
            retryBlock()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        present(alert, animated: true, completion: nil)
    }
}

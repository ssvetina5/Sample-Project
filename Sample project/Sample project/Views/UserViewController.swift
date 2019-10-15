//
//  UserViewController.swift
//  Sample project
//
//  Created by Sven Svetina on 15/10/2019.
//  Copyright © 2019 Sven Svetina. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    var userDetailsViewModel: UserDetailsViewModel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = userDetailsViewModel.name
    }
}
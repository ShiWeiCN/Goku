//
//  ViewController.swift
//  Example
//
//  Created by shiwei on 10/01/2017.
//  Copyright © 2017 shiwei. All rights reserved.
//

import UIKit
import Goku

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goku"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.goku.presentAlert(true, closure: { (make) in
                    make
                        .alert
                        .theme
                        .cancel("Cancel")
                        .destructive("That's all right")
                        .tapped(nil)
                })
            case 1:
                self.goku.presentAlert(true, closure: { make in
                    make.alert
                        .theme
                        .custom(UIView())
                })
            default: break
            }
        }
    }

}


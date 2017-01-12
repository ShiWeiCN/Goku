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
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make
                        .alert
                        .theme
                        .cancel("Cancel")
                        .destructive("That's all right")
                        .tapped(nil)
                })
            case 1:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.alert
                        .theme
                        .title("Awesome")
                        .message("You've just displayed this awesome Pop Up View.")
                        .cancel("Cancel")
                        .destructive("That's all right")
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 2:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.alert
                        .theme
                        .title("Awesome")
                        .message("You've just displayed this awesome Pop Up View.")
                        .cancel("Cancel")
                        .destructive("That's all right")
                        .normal(["Button 1", "Button 2", "Button 3", "Button 4", "Button 5"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            default: break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .actionSheet
                        .title("Okay/Cancel")
                        .message("A customizable action sheet message.")
                        .cancel("Cancel")
                        .destructive("OK")
                        .normal([])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 1:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .actionSheet
                        .title("More")
                        .message("A customizable action sheet message.")
                        .cancel("Cancel")
                        .destructive("OK")
                        .normal(["This is a long long long long long long long long long long long long long long long long long long long long title button 😂", "Button 2", "Button 3"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .alert
                        .success
                        .title("Congratulations!")
                        .message("You've just displayed this awesome Pop Up View.")
                        .cancel("Cancel")
                        .normal(["Default 1", "Default 2"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 1:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .alert
                        .failure
                        .title("Whoopes!")
                        .message("You've just displayed this awesome Pop Up View.")
                        .cancel("Cancel")
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 2:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .alert
                        .warning
                        .title("Whoopes!")
                        .message("You've just displayed this awesome Pop Up View.")
                        .normal(["Button 1", "Button 2", "Button 3"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 3:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .alert
                        .notice
                        .title("Notice!")
                        .message("You've just displayed this awesome Pop Up View.")
                        .normal(["Button 1"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            case 4:
                self.goku.presentAlert(animated: true, closure: { (make) in
                    make.theme
                        .alert
                        .question
                        .title("Question?")
                        .message("You've just displayed this awesome Pop Up View.")
                        .normal(["Button 1"])
                        .tapped({ (index) in
                            print("You just tapped \(index)")
                        }
                    )
                })
            default: break
            }
        }
    }

}


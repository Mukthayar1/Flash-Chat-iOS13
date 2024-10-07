//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    let character = "⚡️FlashChat"
    var characterIndex = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for letter in character {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { Timer in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
    }
    

}

//
//  PlayerTableViewCell.swift
//  Test Hansen iOS
//
//  Created by Alejandro Ruiz Ponce on 09/01/2020.
//  Copyright © 2020 Alejandro Ruiz Ponce. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet var birthDate: UILabel!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var playerSurname: UILabel!
    @IBOutlet var playerImage: UIImageView! {
        didSet {
            let radius = playerImage.frame.width / 2
            playerImage.layer.cornerRadius = radius
            playerImage.layer.masksToBounds = true
        }
    }
  
}

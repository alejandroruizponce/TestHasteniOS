//
//  ViewController.swift
//  Test Hansen iOS
//
//  Created by Alejandro Ruiz Ponce on 09/01/2020.
//  Copyright © 2020 Alejandro Ruiz Ponce. All rights reserved.
//

import UIKit
import Nuke

struct Sport {
    var title: String
    var listPlayers: [Player]
}

struct Player {
    var name: String
    var surname: String
    var image: String
    var date: String? = ""
}

class SportsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cell: PlayerTableViewCell!
    var listPlayers: [Player] = []
    var listSports: [Sport] = []
    var sportsLoaded = false

    @IBOutlet var sportsTable: UITableView! {
        didSet {
            sportsTable.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSports()
    }
    
    func loadSports() {
        InfoAPI.getSports { (sports) in
            self.listSports.removeAll()
            for sport in sports {
                print("El sport escogido es: \(sport)")
                if let sportDict = sport as? NSDictionary {
                    if let players = sportDict.object(forKey: "players") as? NSArray {
                        self.listPlayers.removeAll()
                        for player in players {
                            if let playerDict = player as? NSDictionary {
                                if let namePlayer = playerDict.object(forKey: "name") as? String, let surnamePlayer = playerDict.object(forKey: "surname") as? String, let imagePlayer = playerDict.object(forKey: "image") as? String {
                                    if let datePlayer = playerDict.object(forKey: "date") as? String {
                                        self.listPlayers.append(Player(name: namePlayer, surname: surnamePlayer, image: imagePlayer, date: datePlayer))
                                    } else {
                                        self.listPlayers.append(Player(name: namePlayer, surname: surnamePlayer, image: imagePlayer))
                                    }
                                }
                            }
                        }
                    }
                    if let titleSport = sportDict.object(forKey: "title") as? String {
                        self.listSports.append(Sport(title: titleSport, listPlayers: self.listPlayers))
                    }
                }
            }
            
            self.sportsLoaded = true
            self.sportsTable.alpha = 1.0
            self.sportsTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return listSports.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSports[section].listPlayers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = listSports[section].title

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         cell = sportsTable.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell
        
        if let player = listSports[indexPath.section].listPlayers[indexPath.row] as? Player {
            self.cell.playerName.text = player.name
            self.cell.playerSurname.text = player.surname
            self.cell.birthDate.text = player.date
            
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "placeholder"),
                transition: .fadeIn(duration: 0.33)
            )
            
            if let imageURL = URL(string: player.image) as? URL {
                Nuke.loadImage(with: imageURL, options: options, into: self.cell.playerImage)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
    }
       
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
            listSports[indexPath.section].listPlayers.remove(at: indexPath.row)
            sportsTable.deleteRows(at: [indexPath], with: .fade)
           }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.alpha = 0
           
           UIView.animate(
               withDuration: 0.8,
               delay: 0.0,
               animations: {
                   cell.alpha = 1
           })
       }
}

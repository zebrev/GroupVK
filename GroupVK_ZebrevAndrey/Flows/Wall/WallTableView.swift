//
//  WallTable.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 05.12.2017.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import UIKit

class WallTableView: UITableViewController {

    lazy var photoService = PhotoService(container: tableView)
    
    let mainService = MainService()
    var walls = [Walls]()
    
        @IBAction func addGroup(segue: UIStoryboardSegue) {
           
            
        }

    //при возврате из окна размещения поста - берем текст поста, отправляем в вк на стену и обновляем стенку в приложении
    @IBAction func postWall(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "didPostWall" {
            let postController = unwindSegue.source as! WallPostViewController

            guard
                let textMessage = postController.TextPost.text
                else { return }
            
            
            mainService.postWall(message: textMessage, attachments: nil) {
                
                [weak self] responseString in
                
                if (!responseString.isEmpty) {
//                    print("postWall success ")
                    
                    DispatchQueue.main.async {
                        
                        self?.DownloadData()
                    }
                    
                }

        }
    }
    }

        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 385
//            print("viewDidLoad")
         
            DownloadData()

    }

    func DownloadData() {
        mainService.downloadsWalls() { [weak self] walls in
            
//            print("download walls")
            self?.walls = walls
            self?.tableView.reloadData()
        }

    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return walls.count
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallTableViewCellId", for: indexPath) as! WallTableViewCell
        let new = walls[indexPath.row]
               
        if let mainPhotoUrl = new.photoLink {
            cell.mainImage.image = photoService.photo(atIndexpath: indexPath, byUrl: mainPhotoUrl)
        } else {
            cell.mainImage.image = nil
        }
        cell.mainText.text = new.text
        
        return cell
        
    }

}

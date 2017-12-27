//
//  NewsFeedTableVC.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 30.10.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedVC: UITableViewController {
    
  
    lazy var photoService = PhotoService(container: tableView)

    let mainService = MainService()
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        
        mainService.downloadsNews() { [weak self] news in
            self?.news = news
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
        return news.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCell
        let new = news[indexPath.row]
        
        var autorName = ""
        var autorAvatarUrl = ""
        if let group = new.group {
            autorName = group.name
            autorAvatarUrl = group.photo
            //print(group)
        } else if let user = new.user {
            autorName = user.fullName
            let photoPhotoAvatar = user.photoUrl.isEmpty ? user.photo50Url : user.photoUrl
            autorAvatarUrl = photoPhotoAvatar
            //print(user)
        }
        
        if let mainPhotoUrl = new.photoLink {
            cell.mainImage.image = photoService.photo(atIndexpath: indexPath, byUrl: mainPhotoUrl)
        } else {
            cell.mainImage.image = nil
        }
        
        cell.autorAvatar.image = photoService.photo(atIndexpath: indexPath, byUrl: autorAvatarUrl)
        cell.autorName.text = autorName
        cell.mainText.text = new.text
        cell.likeCount.text = String(describing: new.likesCount)
        cell.commentCount.text = String(describing: new.commentsCount)
        cell.repostCount.text = String(describing: new.repostsCount)
        cell.viewsCount.text = String(describing: new.viewsCount)

        return cell
        
    }
    
}

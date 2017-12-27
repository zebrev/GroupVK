//
//  TableViewControllerUserStory.swift
//  Weather_Zebrev
//
//  Created by Rapax on 26.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerFriends: UITableViewController {

    //создаем экземпляр сервиса
    let mainService = MainService()
    
    lazy var  photoService = PhotoService(container: tableView)
    
    //var arrUser = [User]()

    var users   : Results<User>?
    var token   : NotificationToken?            //токен для уведомлений из базы
    var photos = [Photo]()

    
    /*
    func showFriend() {
        arrUser = mainService.loadFriends()
        tableView.reloadData()
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        arrUser = User.getUserVk(mainService: mainService)
        
        // [weak self]
        

        
       // showFriend()
       
        mainService.loadFriendVK()
        pairTableAndRealm()
            /*{ [weak self] in
            self?.showFriend()
        }
*/
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete implementation, return the number of rows=

//        print (" count = \(arrUser.count)")
        return users?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! TableViewCellFriends
       
        guard let user = users?[indexPath.row] else { return cell }
        
        cell.idFriend = user.id
        
        //print (arrUser[indexPath.row].photo)
        cell.FriendsCellLabel.text  = user.fullName

        //cell.FriendsCellImage.image = UIImage(named: arrUser[indexPath.row].photo)
        //cell.FriendsCellImage.setImageFromURl(stringImageUrl: arrUser[indexPath.row].photo)

        //или универсально или конкретно оутлет указываем
        //cell.imageView?.setImageFromURl(stringImageUrl: arrUser[indexPath.row].photo)
        //cell.FriendsCellImage.setImageFromURl(stringImageUrl: user.photo50)

        /*
        if let photo = usersPhoto[indexPath.row] {
            cell.FriendsCellImage.image = photo
        }
        else {
            loadPhotos(indexPath: indexPath)
        }
        */

        cell.FriendsCellImage.image = photoService.photo(atIndexpath: indexPath, byUrl: user.photoUrl)
        // Configure the cell...

        return cell
    }
    
/*
    func loadPhotos(indexPath: IndexPath) {
        
        guard let photo = users?[indexPath.row].photo50Url else { return }
        photoService.downloadPhoto(byUrl: photo) { [weak self] image in
            self?.usersPhoto[indexPath.row] = image
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMyFriend",
            let newCollectionViewControllerFriendsData = segue.destination as? CollectionViewControllerFriendsData,
            let indexPath2 = tableView.indexPathForSelectedRow,
            let userId = users?[indexPath2.row].id
//let photo = users?[indexPath2.row].photoUrl
            {
            //let cell = sender as! TableViewCellFriends
            //let selectedFriend = arrUser.filter({ $0.id == cell.idFriend })
            /*
                if selectedFriend.count == 0 {
                    fatalError()
                }
 */
            //newCollectionViewControllerFriendsData.photo = photo
            newCollectionViewControllerFriendsData.userId = userId
            }
    }

    
    func  pairTableAndRealm() {
        guard let realm  = try? Realm()  else { return }
        
        users  = realm.objects(User.self)
        token  = users?.observe {  [  weak  self]  (  changes:   RealmCollectionChange)  in
            guard let tableView = self?.tableView  else { return }
            switch  changes {

            case .initial:
                tableView.reloadData()
                
                print("друзья - первая загрузка - обновить таблицу")
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                
                print("друзья - обновление данных в таблице. del=\(deletions), ins = \(insertions), modif = \(modifications)")
                break

            case .error(let error):
                fatalError("друзья - ошибка! \(error)")
                break
            }
        }
    }
}

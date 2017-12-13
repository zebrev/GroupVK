//
//  TableViewControllerUserList.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerGroupList: UITableViewController {

    //создаем экземпляр сервиса
    let mainService = MainService()

    var groups   : Results<Group>?
    var token   : NotificationToken?            //токен для уведомлений из базы

//    var arrGroup = [Group]()

    /*
    func showGroup() {

        arrGroup = mainService.loadGroups()
        tableView.reloadData()

    }
*/
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {

        print("add group")
        mainService.loadGroupVK()
        //не надо ничего добавлять - просто обновить текущие группы пользователя (уже все добавлено)
        //showGroup()

        
        //Проверяем идентификатор перехода, что бы убедится что это нужныий переход
            //if segue.identifier == "addGroup" {
        
                /*
                //получаем ссылку на контроллер с которого осуществлен переход
                let allGroup = segue.source as! TableViewControllerGroupListData

                //получаем индекс выделенной ячейки
                if let indexPath = allGroup.tableView.indexPathForSelectedRow {
                    //получаем город по индксу
                    let group = allGroup.filterGroups[indexPath.row].id

                    print("group = \(group)")
 */
                    /*
                    //Проверяем что такого города нет в списке
                    if !arrGroup.contains(where: group) {
                        //добавляем город в список выбранных городов
                        arrGroup.append(group)
                        //обновляем таблицу
                        tableView.reloadData()
                    }
 */
                //}
                
            //}
            
        }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

                print("did load")
        //showGroup()
/*
        mainService.loadGroupVK() { [weak self] in
            self?.showGroup()
        }
*/
        pairTableAndRealm()
        
        mainService.loadGroupVK()
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
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! TableViewCellGroupList
        
        guard let group = groups?[indexPath.row] else { return cell }
        
        let currentGroupName=group.name + " (" + String(group.countUser) + ")"
        
        cell.idGroup = group.id
        
        //print (arrUser[indexPath.row].photo)
        cell.GroupListCellLabel.text  = currentGroupName
        //cell.FriendsCellImage.image = UIImage(named: arrUser[indexPath.row].photo)
        //cell.FriendsCellImage.setImageFromURl(stringImageUrl: arrUser[indexPath.row].photo)
        
        //или универсально или конкретно оутлет указываем
        //cell.imageView?.setImageFromURl(stringImageUrl: arrUser[indexPath.row].photo)
        cell.GroupListCellImage.setImageFromURl(stringImageUrl: group.photo)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //если была нажата кнопка удалить
        if editingStyle == .delete {

            guard let groupId = groups?[indexPath.row].id else { return }
            //let group = groups[indexPath.row]

           
            mainService.leaveFromGroup(groupID: groupId) {}
            /*
            do {
                let realm  = try  Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            }   catch {
                print(  error)
            }
 */
            //group.remove(at: indexPath.row)
            //и удаляем строку из таблицы
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func  pairTableAndRealm() {
        guard let realm  = try? Realm()  else { return }
        
        groups  = realm.objects(Group.self)
        token  = groups?.addNotificationBlock {  [  weak  self]  (  changes:   RealmCollectionChange)  in
            guard let tableView = self?.tableView  else { return }
            switch  changes {
                
            case .initial:
                tableView.reloadData()
                
                print("group reload notification")
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map( { IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                
                print("group del=\(deletions), ins = \(insertions), modif = \(modifications)")
                break
                
            case .error(let error):
                fatalError(" \(error)")
                break
            }
        }
    }

}

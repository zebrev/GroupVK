//
//  TableViewControllerUserListData.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

class TableViewControllerGroupListData: UITableViewController {


    let mainService = MainService()
    //let delay = Delay()
    var filterGroups = [Group]()
    
//    var isSearching = false

    @IBOutlet weak var searchBar: UISearchBar!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarSetup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func searchBarSetup() {
        //let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.showsScopeBar = true
//        searchBar.scopeButtonTitles = ["Name","People"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar

        searchBar.returnKeyType = UIReturnKeyType.done

        
    }
/*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            //view.endEditing(true)
            self.tableView.reloadData()
        }
        else {
            isSearching = true

            self.mainService.loadAndSearchGroupVK(searchText: searchBar.text!.lowercased()){ [weak self] filterGroups in
                self?.filterGroups = filterGroups
                self?.tableView?.reloadData()
            }

        }
    }
*/
   
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
        return filterGroups.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListDataCell", for: indexPath) as! TableViewCellGroupListData

//        if isSearching {

            cell.GroupListDataCellLabel.text = filterGroups[indexPath.row].name
            cell.GroupListDataCellNumberOfPersonLabel.text = String(filterGroups[indexPath.row].countUser)
            cell.imageView?.setImageFromURl(stringImageUrl: filterGroups[indexPath.row].photo)
//        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = filterGroups[indexPath.row].id
        mainService.joinToGroup(groupID: id) { [weak self] in
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TableViewControllerGroupListData: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let text = searchBar.text,
            !text.isEmpty else {
                
                tableView.reloadData()
                return
        }
        searchGroups(request: text)
        tableView.reloadData()
    }
    
    func searchGroups(request: String) {
        self.mainService.loadAndSearchGroupVK (searchText: request) { [weak self] groups in
            self?.filterGroups = groups
            self?.tableView.reloadData()
        }
    }
}

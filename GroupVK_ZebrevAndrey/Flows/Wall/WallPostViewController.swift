//
//  WallPostViewController.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 21.12.2017.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

class WallPostViewController: UIViewController {
    
    let mainService = MainService()
    
    @IBOutlet weak var TextPost: UITextField!
    
    @IBOutlet weak var TextCoordinates: UITextView!
       
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

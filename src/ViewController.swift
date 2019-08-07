//
//  ViewController.swift
//  Recipe
//
//  Created by Aramis N. Vazquez (Student) on 1/7/19.
//  Copyright © 2019 Aramis N. Vazquez (Student). All rights reserved.
//

//++++++++++++++++++
//main view controller is for the main view to see the recipes listed and to be
//able to edit and delete.
//++++++++++++++++++
//second view controller is for the edit to make changes with the information
//inside of it
//++++++++++++++++++
//third view controller is for the new when trying to make a new recipe
//++++++++++++++++++
import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var homeTBLview: UITableView!
    
    @IBAction func newBtn(_ sender: Any) {
        performSegue(withIdentifier: "toEditRecipe", sender: self)
    }
    
    
    var index = 0
    var item = JSON()
    
    let url = "http://www.tageninformatics.com/client/jwu/csis3070_recipe/"
    
    //var key = "0000000000000000000000000000000000000000000000000000000000000011"
    var key = ""
    var editTitle = ""
    var editDesc = ""
    var editNum = 0
    var id = ""

    //this puts the rows of how many there are
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.item.count)
        return self.item.count
    }

    //sends the specified info to the cells to then get put on the screen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")
        cell?.textLabel?.text = self.item[indexPath.row]["title"].string
        //print(self.item)
        return cell!
    }
    //this will make it able to send through the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row

        //these are to the edit and new screen
        performSegue(withIdentifier: "toViewRecipe", sender: self)
        
        //we need this to be able to send at all
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //this is to edit and delete from main story board
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete")
        {
            action,indexPath in
            //make delete here ========
            let alert = UIAlertController(title: "Are you sure you want to delete this recipe :[",
                                          message: nil,
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: "Confirm", style: .default){
                (action) in
                //you need the item rows id not the whole id itself
                let parameters = ["key":self.key, "id":self.item[indexPath.row]["id"].string!]
                Alamofire.request(self.url + "delete", method: .get, parameters:
                    parameters).responseJSON { response in
                        self.viewDidLoad()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(confirm)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        
        let  editAction = UITableViewRowAction(style: .normal, title: "Edit")
        {
            action,indexPath in
            //make edit here =========
            self.id = self.item[indexPath.row]["id"].string!
            self.editNum = 1
            self.editTitle = self.item[indexPath.row]["title"].string!
            self.editDesc = self.item[indexPath.row]["description"].string!
            
            self.performSegue(withIdentifier: "toEditRecipe", sender: self)
        }
        
        return [deleteAction, editAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toViewRecipe"
        {
            let goToView = segue.destination as! ThirdViewController
            
            //these passes the info from title to the third view controllers title
            goToView.thirdViewTitle = self.item[self.index]["title"].string!
            goToView.thirdViewRecipe = self.item[self.index]["description"].string!
            goToView.key = self.key
        }
        else if segue.identifier == "toEditRecipe"
        {
            let goToEdit = segue.destination as! SecondViewController
            if editNum == 1
            {
                goToEdit.key = self.key
                goToEdit.recipeTitle1 = self.editTitle
                goToEdit.recipeDesc1 = self.editDesc
                goToEdit.editnum = self.editNum
                goToEdit.index = self.id
            }
            else
            {
                goToEdit.key = self.key
            }
        }
        
        //in here you can put seperate segue to different things
        //just add if statements to separate them*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.key = UserDefaults.standard.string(forKey: "key") ?? ""
        if UserDefaults.standard.string(forKey: "key") ?? "" == ""
        {
            print("why")
            //generate key
            var alph = ["a","b","c","d","e","f","1","2","3","4","5","6","7","8","9","0"]
            
            for _ in 0...63
            {
                let make = Int(arc4random_uniform(16))
                let a = alph[make]
                key.append(a)
            }
            UserDefaults.standard.set(self.key, forKey: "key")
        }
        let parameters = ["key":self.key]
        
        Alamofire.request(url + "list", method: .get, parameters:
            parameters).responseJSON { response in
            var r = JSON(response.result.value as Any)
                
            self.item = r["recipes"]
            print (r)
            self.homeTBLview.reloadData()
        }.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

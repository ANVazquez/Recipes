//
//  SecondViewController.swift
//  Recipe
//
//  Created by Aramis N. Vazquez (Student) on 1/8/19.
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
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController{
    @IBOutlet weak var saveTitle: UITextField!
    @IBOutlet weak var saveRecipe: UITextView!
    
    let url = "http://www.tageninformatics.com/client/jwu/csis3070_recipe/"
    var key = ""
    var recipeTitle1 = ""
    var recipeDesc1 = ""
    var editnum = 0
    var index = ""
    
    @IBAction func cancelToView(_ sender: Any) {
        let alert = UIAlertController(title: "Notice",
                                      message: "Are you sure you want to cancel? All information will be lost!",
                                      preferredStyle: .alert)
        let goOn = UIAlertAction(title: "Yes", style: .default) {
            //this makes it so when you click Yes it will bring you back to the other segue
            (action) in
            
            self.performSegue(withIdentifier: "backFromEdit", sender: self)
        }
        alert.addAction(goOn)
        
        let cancelAlert = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(cancelAlert)
        self.present(alert,animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let title = saveTitle.text
        let description = saveRecipe.text
        if editnum == 0
        {
            if title == "" || description == ""
            {
                let alert = UIAlertController(title: "Notice",
                                              message: "A Field is missing. No save for you :]",
                                              preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Make Changes", style: .cancel)
                alert.addAction(cancel)
                self.present(alert,animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Notice",
                                             message: "All set! Would you like to save?",
                                             preferredStyle: .alert)
                let save = UIAlertAction(title: "Save", style: .default) {
                    (action) in
                    let parameters = ["key":self.key, "title": self.saveTitle.text!, "description":self.saveRecipe.text!] as [String : Any]
                    
                    Alamofire.request(self.url + "create", method: .get, parameters: parameters).responseJSON { response in
                        
                        self.performSegue(withIdentifier: "backFromEdit", sender: self)
                    }
                }
                let cancel = UIAlertAction(title: "Make Changes", style: .cancel)
                
                alert.addAction(save)
                alert.addAction(cancel)
                self.present(alert,animated: true)
            }
        }
        if editnum == 1
        {
            if title == "" || description == ""
            {
                let alert = UIAlertController(title: "Notice",
                                              message: "A Field is missing. No save for you :]",
                                              preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Make Changes", style: .cancel)
                alert.addAction(cancel)
                self.present(alert,animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Notice",
                                              message: "All set! Would you like to save?",
                                              preferredStyle: .alert)
                let save = UIAlertAction(title: "Save", style: .default) {
                    (action) in
                    let cut = ["key":self.key, "id":self.index] as [String : Any]
                    print(self.index)
                    Alamofire.request(self.url + "delete", method: .get, parameters: cut).responseJSON { response in
                        
                        let parameters = ["key":self.key, "title": self.saveTitle.text!, "description":self.saveRecipe.text!] as [String: Any]
                        
                        Alamofire.request(self.url + "create", method: .get, parameters: parameters).responseJSON { response in
                            
                            self.performSegue(withIdentifier: "backFromEdit", sender: self)
                        }
                    }
                    
                }
                let cancel = UIAlertAction(title: "Make Changes", style: .cancel)
                
                alert.addAction(save)
                alert.addAction(cancel)
                self.present(alert,animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveRecipe.text = recipeDesc1
        self.saveTitle.text = recipeTitle1
        //print(self.key)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

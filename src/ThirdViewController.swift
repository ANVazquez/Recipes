//
//  ThirdViewController.swift
//  Recipe
//
//  Created by Aramis N. Vazquez (Student) on 1/9/19.
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

class ThirdViewController: UIViewController {
    @IBOutlet weak var viewsRecipesTitle: UITextField!
    @IBOutlet weak var viewsRecipe: UITextView!
    
    @IBAction func backBtnToView(_ sender: Any) {
        performSegue(withIdentifier: "backFromView", sender: self)
        //print("going back")
    }
    
    //these are empty string placeholders
    var thirdViewTitle = ""
    var thirdViewRecipe = ""
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewsRecipesTitle.text = self.thirdViewTitle
        self.viewsRecipe.text = self.thirdViewRecipe
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

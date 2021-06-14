//
//  ViewController.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 08/06/21.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupAccessbility()
    }

    let cornerMenu = CGFloat(8)  //besar corner radius
    
    @IBOutlet weak var menu1Title1: UILabel!
    @IBOutlet weak var menu1Title2: UILabel!
    @IBOutlet weak var menu1Description: UILabel!
    @IBOutlet weak var menu1Image: UIImageView!
    @IBOutlet weak var menu1View: UIView!
    
    
    @IBOutlet weak var menu2Title1: UILabel!
    @IBOutlet weak var menu2Title2: UILabel!
    @IBOutlet weak var menu2Description: UILabel!
    @IBOutlet weak var menu2Image: UIImageView!
    @IBOutlet weak var menu2View: UIView!
    
    @IBOutlet weak var menu3Title1: UILabel!
    @IBOutlet weak var menu3Title2: UILabel!
    @IBOutlet weak var menu3Description: UILabel!
    @IBOutlet weak var menu3Image: UIImageView!
    @IBOutlet weak var menu3View: UIView!
    
    
    func setupMenu() {
        let menuList = MenuListStaticSeeder.getMenu()
        
        menu1Title1.text = menuList[0].title1
        menu1Title2.text = menuList[0].title2
        menu1Description.text = menuList[0].description
        menu1Image.image = menuList[0].getImage()
        menu1View.backgroundColor = menuList[0].getColor()
        menu1View.layer.cornerRadius = cornerMenu
        
        menu2Title1.text = menuList[1].title1
        menu2Title2.text = menuList[1].title2
        menu2Description.text = menuList[1].description
        menu2Image.image = menuList[1].getImage()
        menu2View.backgroundColor = menuList[1].getColor()
        menu2View.layer.cornerRadius = cornerMenu

        menu3Title1.text = menuList[2].title1
        menu3Title2.text = menuList[2].title2
        menu3Description.text = menuList[2].description
        menu3Image.image = menuList[2].getImage()
        menu3View.backgroundColor = menuList[2].getColor()
        menu3View.layer.cornerRadius = cornerMenu

    }
    
    func setupAccessbility() {
//        logoImage.isAccessibilityElement = true
//        logoImage.accessibilityTraits = .none
//        logoImage.accessibilityLabel = "Welcome to Main Page. There are 3 button you can choose."
        
        self.navigationItem.accessibilityLabel = "Welcome to Main Page. There are 3 button you can choose."
        
        
        //menu 1
        menu1Title1.isAccessibilityElement = false
        menu1Title2.isAccessibilityElement = false
        menu1Description.isAccessibilityElement = false
        menu1Image.isAccessibilityElement = false
        
        menu1View.isAccessibilityElement = true
        menu1View.accessibilityTraits = .button
        menu1View.accessibilityLabel = (menu1Title1.text!  + " " + menu1Title2.text! + " " + menu1Description.text!)

        //menu 2
        menu2Title1.isAccessibilityElement = false
        menu2Title2.isAccessibilityElement = false
        menu2Description.isAccessibilityElement = false
        menu2Image.isAccessibilityElement = false
        
        menu2View.isAccessibilityElement = true
        menu2View.accessibilityTraits = .button
        menu2View.accessibilityLabel = (menu2Title1.text!  + " " + menu2Title2.text! + " " + menu2Description.text!)

        //menu 3
        menu3Title1.isAccessibilityElement = false
        menu3Title2.isAccessibilityElement = false
        menu3Description.isAccessibilityElement = false
        menu3Image.isAccessibilityElement = false
        
        menu3View.isAccessibilityElement = true
        menu3View.accessibilityTraits = .button
        menu3View.accessibilityLabel = (menu3Title1.text!  + " " + menu3Title2.text! + " " + menu3Description.text!)
        
    }
    
    @IBAction func didTabMenu1(_ sender: Any) {
        performSegue(withIdentifier: "scanFlowchartSegue", sender: self)
    }
    
    @IBAction func didTabMenu2(_ sender: Any) {
        performSegue(withIdentifier: "listProjectSegue", sender: self)
    }
    
    @IBAction func didTabMenu3(_ sender: Any) {
        print("Menu 3 Tabbed")
    }
}


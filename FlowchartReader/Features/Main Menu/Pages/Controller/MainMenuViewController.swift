//
//  ViewController.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 08/06/21.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupAccessbility()
    }
    
    let cornerMenu = CGFloat(8)  //besar corner radius
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
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
        navigationTitle.accessibilityLabel = "Main Page. There are 3 button you can choose."
        
        menu1View.isAccessibilityElement = true
        menu1View.accessibilityElements = [menu1Title1!, menu1Title2!, menu1Description!, menu1Image!]
        menu1View.accessibilityTraits = .button
        menu1View.accessibilityLabel = menu1Title1.text!  + " " + menu1Title2.text!
        menu1View.accessibilityHint = menu1Description.text!
        
        //menu 2
        menu2View.isAccessibilityElement = true
        menu2View.accessibilityElements = [menu2Title1!, menu2Title2!, menu2Description!, menu2Image!]
        menu2View.accessibilityTraits = .button
        menu2View.accessibilityLabel = menu2Title1.text!  + " " + menu2Title2.text!
        menu2View.accessibilityHint = menu2Description.text!
        
        
        //menu 3
        menu3View.isAccessibilityElement = true
        menu3View.accessibilityElements = [menu3Title1!, menu3Title2!, menu3Description!, menu3Image!]
        menu3View.accessibilityTraits = .button
        menu3View.accessibilityLabel = menu3Title1.text!  + " " + menu3Title2.text!
        menu3View.accessibilityHint = menu3Description.text!
        
    }
    
    @IBAction func didTabMenu1(_ sender: Any) {
        performSegue(withIdentifier: "scanFlowchartSegue", sender: self)
    }
    
    @IBAction func didTabMenu2(_ sender: Any) {
        performSegue(withIdentifier: "listProjectSegue", sender: self)
    }
    
    @IBAction func didTabMenu3(_ sender: Any) {
        performSegue(withIdentifier: "segueToGuidance", sender: self)
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}


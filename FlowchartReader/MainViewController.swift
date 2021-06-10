//
//  ViewController.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 08/06/21.
//

import UIKit

class MainViewController: UIViewController {
    //daftar menu -> generate 3 menu
    var menuList = MenuListStaticSeeder.getMenu()
    
    
    @IBOutlet weak var tableMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableMenu.dataSource = self
        let nib = UINib(nibName: "MainMenuTableViewCell", bundle: nil)
        tableMenu.register(nib, forCellReuseIdentifier: "menuCell")
        
//        tableMenu.rowHeight = tableMenu.contentSize.height / 4
    }

//    override func viewWillAppear(_ animated: Bool) {
//        tableMenu.rowHeight = tableMenu.contentSize.height / 4
//    }
}


extension MainViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MainMenuTableViewCell
        
        cell.menu = menuList[indexPath.row]
        
        return cell
    }
    
    
}

//
//  SecondViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 14/06/21.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageData: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        imageView.image = imageData
        // Do any additional setup after loading the view.
    }

}

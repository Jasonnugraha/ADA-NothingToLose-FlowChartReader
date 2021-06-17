//
//  ResultViewController.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

// BUAT DELETION KALO ADA YANG DUPLIKAT DUPLIKAT


import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    var resultImage : UIImage?
    
    var flowchartDetails : [FlowchartDetail]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = resultImage{
            resultImageView.image = image
        }
        
        print("this is from controller")
        print(flowchartDetails)
    }
}

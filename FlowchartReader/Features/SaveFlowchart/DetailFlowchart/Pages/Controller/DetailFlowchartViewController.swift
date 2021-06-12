//
//  DetailFlowchartViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class DetailFlowchartViewController: UIViewController {
    
    @IBOutlet var detailFlowchartView: DetailFlowchartView!
    
    var idProject: String?
    var titleProject: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataId = idProject as? String {
            detailFlowchartView.setId(dataId)
        }
        
        self.title = titleProject!
        // Do any additional setup after loading the view.
    }

}

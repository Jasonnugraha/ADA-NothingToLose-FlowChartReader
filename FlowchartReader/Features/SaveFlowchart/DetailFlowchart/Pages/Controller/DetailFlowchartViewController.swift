//
//  DetailFlowchartViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class DetailFlowchartViewController: UIViewController {
    
    @IBOutlet var detailFlowchartView: DetailFlowchartView!
    
    var idFlowchart: String?
    var titleFlowchart: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataId = idFlowchart as? String {
            detailFlowchartView.setId(dataId)
        }
        
        self.title = titleFlowchart!
        // Do any additional setup after loading the view.
    }

}

//
//  DetailFlowchartView.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class DetailFlowchartView: UIView {
    let navbarItem = UINavigationItem()
    
    @IBOutlet weak var idLabel: UILabel!
    
    func setId(_ id: String) {
        idLabel.text = id
    }
    
    func setTitle(_ title: String) {
        navbarItem.title = title
    }
}

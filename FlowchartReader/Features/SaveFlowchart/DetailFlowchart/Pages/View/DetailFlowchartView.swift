//
//  DetailFlowchartView.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class DetailFlowchartView: UIView {
    let navbarItem = UINavigationItem()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    func setId(_ id: UUID) {
        idLabel.text = "\(id)"
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

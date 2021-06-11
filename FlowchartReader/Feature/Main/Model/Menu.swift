//
//  Menu.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 09/06/21.
//

import UIKit

class Menu {
    var title1: String?
    var title2: String?
    var description: String?
    var imageName: String?
    var colorName: String?
    
    func getImage() -> UIImage {
        return UIImage(named: imageName ?? "guidance")!
    }
    
    func getColor() -> UIColor {
        return UIColor(named: colorName ?? "clRed")!
    }
    
    init(pTitle1: String, pTitle2: String, pdescriptions:String, pImageName: String, pColor: String) {
        self.title1 = pTitle1
        self.title2 = pTitle2
        self.description = pdescriptions
        self.imageName = pImageName
        self.colorName = pColor
    }
}

//
//  MenuStaticSeeder.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 10/06/21.
//

import Foundation

class MenuListStaticSeeder {
    
    static func getMenu() -> [Menu] {
        var menuList = [Menu]()
        
        menuList.append(Menu(pTitle1: "Scan", pTitle2: "Flowchart", pdescriptions: "desc", pImageName: "scan", pColor: "clYellow"))
        menuList.append(Menu(pTitle1: "Saved", pTitle2: "Flowchart", pdescriptions: "desc", pImageName: "saved", pColor: "clGreen"))
        menuList.append(Menu(pTitle1: "Listen", pTitle2: "Guidance", pdescriptions: "desc", pImageName: "guidance", pColor: "clRed"))
        
        return menuList
    
    }
}

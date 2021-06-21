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
        
        menuList.append(Menu(pTitle1: "Scan", pTitle2: "Flowchart", pdescriptions: "Scan image of flowchart and read it", pImageName: "scan", pColor: "clYellow"))
        menuList.append(Menu(pTitle1: "Saved", pTitle2: "Flowchart", pdescriptions: "Open your saved flowchart here", pImageName: "saved", pColor: "clGreen"))
        menuList.append(Menu(pTitle1: "Listen", pTitle2: "Guidance", pdescriptions: "Information about flowchart and how to use SeeDiagram", pImageName: "guidance", pColor: "clRed"))
        
        return menuList
    
    }
}

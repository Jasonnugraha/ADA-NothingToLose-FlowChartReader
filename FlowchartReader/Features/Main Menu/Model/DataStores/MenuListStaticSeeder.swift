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
        
        menuList.append(Menu(pTitle1: "Scan", pTitle2: "Flowchart", pdescriptions: "Chooses camera or image library and read it", pImageName: "scan", pColor: "clYellow"))
        menuList.append(Menu(pTitle1: "Saved", pTitle2: "Flowchart", pdescriptions: "Open your file and read it", pImageName: "saved", pColor: "clGreen"))
        menuList.append(Menu(pTitle1: "Listen", pTitle2: "Guidance", pdescriptions: "Information about flowchart", pImageName: "guidance", pColor: "clRed"))
        
        return menuList
    
    }
}

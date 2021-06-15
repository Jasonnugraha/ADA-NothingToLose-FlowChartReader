//
//  GuidanceTableDelegate.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 14/06/21.
//

import Foundation

protocol GuidanceTableDelegate {
    func guidanceTitleDidTab(journalID: Int)
    func guidanceBackDidTab() 
}

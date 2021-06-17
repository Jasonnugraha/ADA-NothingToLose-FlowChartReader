//
//  GuidanceUIView.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 13/06/21.
//

import UIKit

class GuidanceUIView: UIView {

    @IBOutlet weak var guidanceTable : UITableView!
    @IBOutlet weak var guidanceBackButton : UIButton!
    @IBOutlet weak var guidanceNavigator : UINavigationItem!
    
    var guidanceList = [Guidance]()
    var delegate : GuidanceTableDelegate?
    
    func setup(pDelegate : GuidanceTableDelegate)  {
        delegate = pDelegate

        guidanceTable.delegate = self
        guidanceTable.dataSource = self
    }
    
    
    @IBAction func guidanceBackTab(_ sender: Any) {
        delegate?.guidanceBackDidTab()
    }
    
    func  setupAccessbility() {
        guidanceBackButton.accessibilityLabel = "Back"
    }
}

extension GuidanceUIView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guidanceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guidanceCell") as! GuidanceTableViewCell
        
        cell.journalTitle.text = guidanceList[indexPath.row].title
        
        cell.journalTitle.isAccessibilityElement = true
        cell.journalTitle.accessibilityTraits = .link
        cell.journalTitle.accessibilityLabel = cell.journalTitle.text
 
        return cell
    }
    
    
}

extension GuidanceUIView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.guidanceTitleDidTab(journalID: indexPath.row)
    }
    
    
}


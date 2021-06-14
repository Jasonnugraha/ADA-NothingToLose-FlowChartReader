//
//  GuidanceViewController.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 09/06/21.
//

import UIKit

class GuidanceViewController: UIViewController {

    @IBOutlet weak var guidanceView : GuidanceUIView!
    
    var journalID : Int?
    var guidanceList : [Guidance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guidanceList = GuidanceStaticSeeder.getGuidance()

        guidanceView.guidanceList = guidanceList
        guidanceView.setup(pDelegate: self)
        
        guidanceView.setupAccessbility()
        
    }   
    
    @IBAction func unwindToGuidance(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
}

extension GuidanceViewController: GuidanceTableDelegate {
    
    func guidanceBackDidTab() {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    func guidanceTitleDidTab(journalID: Int) {
        self.journalID = journalID
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail"
        {
            if let dest = segue.destination as? GuidanceDetailViewController {
                dest.guidanceTitle = guidanceList[journalID!].title
                dest.guidanceDescription = guidanceList[journalID!].description
            }
        }
    }
    
    
}

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
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GuidanceViewController: GuidanceTableDelegate {
    func guidanceBackDidTab() {
        print ("back")
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

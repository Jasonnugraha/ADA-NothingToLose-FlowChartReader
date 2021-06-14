//
//  GuidanceDetailViewController.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 14/06/21.
//

import UIKit

class GuidanceDetailViewController: UIViewController {
    @IBOutlet weak var guidanceDetailView : GuidanceDetailUIView!
    
    var guidanceTitle : String?
    var guidanceDescription : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guidanceDetailView.setup(pDelegate: self)
        //isi detail guidance
        setupDetail()
    }
    
    func setupDetail() {
        guidanceDetailView.setTitle(pTitle: guidanceTitle!)
        guidanceDetailView.setDescription(pDescription: guidanceDescription!)
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

extension GuidanceDetailViewController : GuidanceDetailDelegate
{
    func detailBackDidTab() {
        print("back")
    }
    
    
}

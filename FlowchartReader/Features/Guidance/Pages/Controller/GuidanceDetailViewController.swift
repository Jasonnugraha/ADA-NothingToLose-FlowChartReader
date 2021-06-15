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
        
        //accessbility harus dipanggil setelah setupDetail
        guidanceDetailView.setupAccessbility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ganti focus ke isi guidance
        
        guidanceDetailView.setupAccessbilityOrder()
        
    }
    
    func setupDetail() {
        guidanceDetailView.setTitle(pTitle: guidanceTitle!)
        guidanceDetailView.setDescription(pDescription: guidanceDescription!)
    }
    

}

extension GuidanceDetailViewController : GuidanceDetailDelegate
{
    func detailBackDidTab() {
            performSegue(withIdentifier: "unwindToGuidance", sender: self)
    }
    
    
}

//
//  GuidanceDetailUIView.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 14/06/21.
//

import UIKit

class GuidanceDetailUIView: UIView {

    @IBOutlet weak var navigationTitle : UINavigationItem!
    @IBOutlet weak var textView : UITextView!
    
    var delegate : GuidanceDetailDelegate?
    
    func setup(pDelegate : GuidanceDetailDelegate)
    {
        self.delegate = pDelegate
    }
    
    func setTitle(pTitle: String) {
        navigationTitle.title = pTitle
    }
    
    func setDescription(pDescription : String) {
        self.textView.text = pDescription
    }
    
    @IBAction func backDidTab(_ sender: Any) {
        delegate?.detailBackDidTab()
    }
    
    
}

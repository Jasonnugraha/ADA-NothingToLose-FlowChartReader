//
//  MainMenuTableViewCell.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 09/06/21.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle1 : UILabel!
    @IBOutlet weak var lbTitle2 : UILabel!
    @IBOutlet weak var lbDescriptions : UILabel!
    @IBOutlet weak var imMenu : UIImageView!
    @IBOutlet weak var vwCell : UIView!
    
    var menu : Menu?
    {
        didSet{
            setupView()
        }
    }
    
    func setupView() {
        lbTitle1.text = menu?.title1
        lbTitle2.text = menu?.title2
        lbDescriptions.text = menu?.description
        imMenu.image = menu?.getImage()
        vwCell.layer.cornerRadius = 8
        vwCell.backgroundColor = menu?.getColor()
    }
    
    
}

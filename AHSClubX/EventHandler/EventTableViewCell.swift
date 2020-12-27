//
//  EventTableViewCell.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/15/20.
//
 
import UIKit
 
class EventTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var eventTypeBanner: UIView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
 
}

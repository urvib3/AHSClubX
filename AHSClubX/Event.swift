//
//  Event.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/15/20.
//

import UIKit

class Event {
    
    //MARK: Properties
    
    var name: String
    var club: String?
    var link: String?
    var type: Int
    
    //MARK: Initialization
    
    init?(name: String, club: String?, link: String?, type: Int) {
        
        // If name is empty or type not in right range, initializing fails
        guard !name.isEmpty && type >= 1 && type <= 3 else {
            return nil
        }
        
        // Initialize stored properteis
        self.name = name
        self.club = club
        self.link = link
        self.type = type
    }
}

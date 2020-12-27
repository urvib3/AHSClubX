//
//  Event.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/15/20.
//
 
import UIKit
import os.log
 
class Event: NSObject, NSCoding, Codable {
    
    //MARK: Properties
    
    var name: String
    var club: String?
    var link: String?
    var type: Int
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let club = "club"
        static let link = "link"
        static let type = "type"
    }
    
    //MARK: Initialization
    
    init?(name: String, club: String?, link: String?, type: Int) {
        
        // If name is empty or type not in right range, initializing fails
        guard !name.isEmpty && type >= 0 && type <= 2 else {
            return nil
        }
        
        // Initialize stored properteis
        self.name = name
        self.club = club
        self.link = link
        self.type = type
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(club, forKey: PropertyKey.club)
        aCoder.encode(link, forKey: PropertyKey.link)
        aCoder.encode(type, forKey: PropertyKey.type)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Club, Link, and Type are optional so a conditional cast suffices.
        let club = aDecoder.decodeObject(forKey: PropertyKey.club) as? String
        
        let link = aDecoder.decodeObject(forKey: PropertyKey.link) as? String
        
        let type = aDecoder.decodeInteger(forKey: PropertyKey.type)
        
        // Must call designated initializer.
        self.init(name: name, club: club, link: link, type: type)
        
    }
    
    
}

//  EventTableViewController.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/14/20.
//
 
import UIKit
import os.log
 
class EventTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    var events = [Event]()
    var eventTypeColors = [UIColor(named:"base1"), UIColor(named: "base2"), UIColor(named: "base3")]
    @IBOutlet weak var addEventButtonItem: UIBarButtonItem!
    @IBOutlet weak var editEventButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the edit button item provided by the table view controller to the right part of navigation bar.
        navigationItem.rightBarButtonItems = [addEventButtonItem, editButtonItem]

    
        // Load any saved events, otherwise load sample data.
        if let savedEvents = loadEvents() {
            print("events saved: ", savedEvents)
            events += savedEvents
        }
        else {
            // Load the sample data.
            print("sample data loaded")
            loadSampleEvents()
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        
            
        case "AddEvent":
            os_log("Adding a new event.", log: OSLog.default, type: .debug)
            
        case "ShowEventDetail":
            guard let eventEditorViewController = segue.destination as? EventEditorViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEventCell = sender as? EventTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEvent = events[indexPath.row]
            eventEditorViewController.event = selectedEvent
            
        default:
            print("User signing out")
            // User signing out using unwindToLogin
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleEvents() {
        
        guard let event1 = Event(name: "pizza", club: "dominoes", link: "", type: 0) else {
            fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(name: "sushi", club: "harumi", link: "", type: 1) else {
            fatalError("Unable to instantiate event1")
        }
        
        guard let event3 = Event(name: "wings", club: "buffalo", link: "", type: 2) else {
            fatalError("Unable to instantiate event1")
        }
 
        
        events += [event1, event2, event3]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        // Fetches the appropriate event for the data source layout.
        let event = events[indexPath.row]
        
        cell.eventName.text = event.name
        cell.clubName.text = event.club
        cell.eventTypeBanner.backgroundColor = eventTypeColors[event.type]
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            events.remove(at: indexPath.row)
            saveEvents()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    private func saveEvents() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(events, toFile: Event.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Events successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save events...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: Actions
    
    /*@IBAction func editEvent(_ sender: Any) {
        addEventButtonItem.isEnabled = false
    }*/
    
    
    // configure event recieved from event into table view
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EventEditorViewController, let event = sourceViewController.event {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing event.
                events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new event.
                let newIndexPath = IndexPath(row: events.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the Events.
            saveEvents()
        }
    }
    
    private func loadEvents() -> [Event]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Event.ArchiveURL.path) as? [Event]
    }
    
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        saveEvents()
        
    }
    
}


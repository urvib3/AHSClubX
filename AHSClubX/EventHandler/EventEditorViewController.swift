//  EventEditorViewController.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/14/20.
//
 
import UIKit
import os.log
 
class EventEditorViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        eventNameTextField.delegate = self
        clubNameTextField.delegate = self
        linkTextField.delegate = self
        
        // Set up views if editing an existing event.
        if let event = event {
            navigationItem.title = event.name
            eventNameTextField.text = event.name
            clubNameTextField.text = event.club
            linkTextField.text = event.link
            eventTypeSegmentedControl.selectedSegmentIndex = event.type
        }
        
        // Enable the Save button only if the text field has a valid event name.
        updateSaveButtonState()
 
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // set text of correspondig text field after user finishes editing
        if(textField == eventNameTextField) { eventNameTextField.text = textField.text }
        if(textField == clubNameTextField) { clubNameTextField.text = textField.text }
        if(textField == linkTextField) { linkTextField.text = textField.text }
        
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // saves event before event editor returns to table view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = eventNameTextField.text
        let club = clubNameTextField.text
        let link = linkTextField.text
        let type = eventTypeSegmentedControl.selectedSegmentIndex
        
        // Set the event to be passed to eventTableViewController after the unwind segue.
        event = Event(name: name ?? "", club: club, link: link, type: type)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = eventNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

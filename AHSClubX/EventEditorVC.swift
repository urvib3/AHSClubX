//
//  EventEditorViewController.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/14/20.
//

import UIKit

class EventEditorVC: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var eventEditorPopup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

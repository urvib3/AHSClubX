//
//  ViewController.swift
//  AHSClubX
//
//  Created by Anju Bhuwania on 11/17/20.
//

import UIKit
import GoogleSignIn

// Match the ObjC symbol name inside Main.storyboard.
@objc(LoginVC)
// [START viewcontroller_interfaces]
class LoginVC: UIViewController {
// [END viewcontroller_interfaces]

  // [START viewcontroller_vars]
  @IBOutlet weak var signInButton: GIDSignInButton!
  @IBOutlet weak var statusText: UILabel!
  // [END viewcontroller_vars]
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

  // [START viewdidload]
    override func viewDidLoad() {
    super.viewDidLoad()
   
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    GIDSignIn.sharedInstance()?.presentingViewController = self

    // Automatically sign in the user.
    GIDSignIn.sharedInstance()?.restorePreviousSignIn()

    /*// Setup allowing CalendarVC to access buttons
    NotificationCenter.default.addObserver(self, selector: #selector(prepFromCalendar), name: NSNotification.Name(rawValue: "prepFromCalendar"), object: nil)*/

    
    // [START_EXCLUDE]
    NotificationCenter.default.addObserver(self,
        selector: #selector(LoginVC.receiveToggleAuthUINotification(_:)),
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)

    statusText.text = "Initialized Swift app..."
    toggleAuthUI()
    // [END_EXCLUDE]
  }
  // [END viewdidload]

  // [START signout_tapped]
  @IBAction func didTapSignOut(_ sender: AnyObject) {
    GIDSignIn.sharedInstance().signOut()
    // [START_EXCLUDE silent]
    statusText.text = "Signed out."
    toggleAuthUI()
    // [END_EXCLUDE]
  }
  // [END signout_tapped]

  // [START disconnect_tapped]
  @IBAction func didTapDisconnect(_ sender: AnyObject) {
    GIDSignIn.sharedInstance().disconnect()
    // [START_EXCLUDE silent]
    statusText.text = "Disconnecting."
    // [END_EXCLUDE]
  }
  // [END disconnect_tapped]

  // [START toggle_auth]
  func toggleAuthUI() {
    if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
      // Signed in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "HomeTBC")
      vc.modalPresentationStyle = .fullScreen
        self.view.window?.rootViewController?.present(vc, animated: true, completion: nil)
      //self.present(vc, animated: false, completion: nil)
        
    } else {
      // Signed out
    }
  }
  // [END toggle_auth]
    
  @objc func prepFromCalendar() {
    print("Received Notification")
    // insert any code needed to update Login Page from Calendar View before segue
    //self.modalPresentationStyle = .fullScreen
    //self.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
    statusText.text = "User signed out"
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }

  deinit {
    NotificationCenter.default.removeObserver(self,
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)
  }

  @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
    if notification.name.rawValue == "ToggleAuthUINotification" {
      self.toggleAuthUI()
      if notification.userInfo != nil {
        guard let userInfo = notification.userInfo as? [String:String] else { return }
        self.statusText.text = userInfo["statusText"]!
      }
    }
  }

}

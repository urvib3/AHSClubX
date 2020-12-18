//
//  EventTableVC.swift
//  AHSClubX
//
//  Created by Urvi Bhuwania on 12/15/20.
//

import UIKit
import GoogleSignIn


// [START viewcontroller_interfaces]
class EventTableVC: UIViewController, UINavigationControllerDelegate {
// [END viewcontroller_interfaces]

  // [START viewdidload]
  override func viewDidLoad() {
    super.viewDidLoad()

    GIDSignIn.sharedInstance()?.presentingViewController = self
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signOutToLoginPage") {
            /// let signInVC = segue.destination as! LoginVC;
            print("hi")
            GIDSignIn.sharedInstance()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            /// NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prepFromCalendar"), object: nil)
            /// signInVC.toggleAuthUI()
        }
    }
}

//
//  ViewController.swift
//  AHSClubX
//
//  Created by Anju Bhuwania on 11/17/20.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit

// Match the ObjC symbol name inside Main.storyboard.
@objc(LoginVC)
// [START viewcontroller_interfaces]
class LoginViewController: UIViewController, LoginButtonDelegate {
    
        // [END viewcontroller_interfaces]

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

  // [START viewdidload]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // google sign in config
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
            
        // Setup allowing CalendarVC to access buttons
        NotificationCenter.default.addObserver(self, selector: #selector(prepFromCalendar), name: NSNotification.Name(rawValue: "prepFromCalendar"), object: nil)

            
        // google sign in buttn auto layout
        signInButton.center = view.center
            
        // facebook login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // facebook log in config
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
        // request additional read permissions
        loginButton.permissions = ["public_profile", "email"]
            
            
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
            selector: #selector(LoginViewController.receiveToggleAuthUINotification(_:)),
            name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil)

        toggleAuthUI()
        // [END_EXCLUDE]
  }
  // [END viewdidload]

  // [START disconnect_tapped]
  @IBAction func didTapDisconnect(_ sender: AnyObject) {
    
    GIDSignIn.sharedInstance().disconnect()
  }
  // [END disconnect_tapped]

  // [START toggle_auth]
  func toggleAuthUI() {
    if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
      // Signed in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: false, completion: nil)
        
    } else {
      // Signed out
    }
  }
  // [END toggle_auth]
    
  //MARK: Navigation
    
    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {
        if sender.source is EventTableViewController {
            
            // google sign out
            GIDSignIn.sharedInstance()?.signOut()
            
            // facebook log out
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
              
        }
    }
    
  @objc func prepFromCalendar() {
    print("Received Notification")
    // insert any code needed to update Login Page from Calendar View before segue
    //self.modalPresentationStyle = .fullScreen
    //self.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
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
    }
  }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            print("inside login button function vc")
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // access and exchange access token for user for a Firebase credential
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("authentication error \(error.localizedDescription)")
                }
                else {
                    print("successfully logged into firebase")
                }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("user signed out")
    }

}

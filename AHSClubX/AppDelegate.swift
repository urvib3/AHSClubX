//
//  AppDelegate.swift
//  AHSClubX
//
//  Created by Anju Bhuwania on 11/17/20.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FBSDKLoginKit

@UIApplicationMain
// [START appdelegate_interfaces]
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("user signed out")
    }
    
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          // [START_EXCLUDE silent]
          NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
          // [END_EXCLUDE]
          return
        }
        
        guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("authentication error \(error.localizedDescription)")
            }
        }
      // Perform any operations on signed in user here.
      let fullName = user.profile.name
      
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
      // [END_EXCLUDE]
    }
    // [END signin_handler]

  // [END appdelegate_interfaces]
  var window: UIWindow?

  // [START didfinishlaunching]
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    
    // Facebook login
    ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
    
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self

    
    return true
  }
  // [END didfinishlaunching]
    
    // facebook log in
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        print("inside login button function delegate")
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
        
  // [START openurl]
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        // google sign in
        return GIDSignIn.sharedInstance().handle(url)
        
    }
  // [END openurl]

  // [START openurl_new]
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        
        print("above facebook log in url='")
        // facebook log in
        ApplicationDelegate.shared.application(
                    application,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
        
        
        // google sign in
      return GIDSignIn.sharedInstance().handle(url)
    }
  // [END openurl_new]

  // [START disconnect_handler]
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
            withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    NotificationCenter.default.post(
      name: Notification.Name(rawValue: "ToggleAuthUINotification"),
      object: nil,
      userInfo: ["statusText": "User has disconnected."])
    // [END_EXCLUDE]
  }
  // [END disconnect_handler]
}
    }

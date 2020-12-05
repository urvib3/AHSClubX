import UIKit
import GoogleSignIn


// [START viewcontroller_interfaces]
class CalendarViewController: UIViewController, UINavigationControllerDelegate {
// [END viewcontroller_interfaces]

  // [START viewdidload]
  override func viewDidLoad() {
    super.viewDidLoad()

    GIDSignIn.sharedInstance()?.presentingViewController = self
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signOutToLoginPage") {
            //let signInVC = segue.destination as! LoginVC;
            GIDSignIn.sharedInstance()?.signOut()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "prepFromCalendar"), object: nil)
            // signInVC.toggleAuthUI()
        }
    }
}

//
//  SignInViewController.swift
//  TipReporter
//
//  Created by Soupy Campbell on 5/15/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        Firebase.shared.updateUser(nameInput.text!) { success in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "tabBarControllerSegue", sender: self)
                }
            } else {
                // Handle error case
            }

        }
    }
    
    @objc func googleSignInFunction(sender: Any) {
      GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
          guard error == nil else { return }
          guard let signInResult = signInResult else { return }

          let user = signInResult.user

          let emailAddress = user.profile?.email

          let fullName = user.profile?.name
          let givenName = user.profile?.givenName
          let familyName = user.profile?.familyName

          let profilePicUrl = user.profile?.imageURL(withDimension: 320)

          AddTipsViewController.shared.updateUser(emailAddress!) { success in
              if success {
                  DispatchQueue.main.async {
                      self.performSegue(withIdentifier: "tabBarControllerSegue", sender: self)
                  }
              } else {
                  // Handle error case
                  print("Error")
              }

          }
          
          Firebase.shared.updateUser(emailAddress!) { success in
              if success {
                  DispatchQueue.main.async {
                      self.performSegue(withIdentifier: "tabBarControllerSegue", sender: self)
                  }
              } else {
                  // Handle error case
                  print("Error")
              }

          }
      }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Google Sign In
        let googleSignIn = GIDSignInButton()
        googleSignIn.colorScheme = GIDSignInButtonColorScheme.dark
        googleSignIn.style = GIDSignInButtonStyle.iconOnly
        googleSignIn.sizeToFit()
        googleSignIn.center = view.center
        googleSignIn.addTarget(self, action: #selector(googleSignInFunction), for: .touchUpInside)

        view.addSubview(googleSignIn)
        NSLayoutConstraint.activate([
            googleSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignIn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

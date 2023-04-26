//
//  SignUpViewController.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-24.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpElements()
        
    }
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    // Kollar om korrekt data är inmatad, om så är fallet så returnerar den nill. Annars så returnerar den ett error meddelande.
    func validateFields() -> String? {
        
        // Kollar om alla fields är ifyllda.
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "Please fill in all the fields."
        }
        
        // kollar om lösenordet är säkert annars returnerar ett error meddelande.
        let checkPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(checkPassword) == false {
            return "Please make sure your password is atleast 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            // Visar upp error meddelande
            showError(error!)
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // skapar användare
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    showError("Could not create user")
                } else {
                    
                    // Användare är skapad, kommer nu att lagra first och lastname i databasen.
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            showError("Error saving user data")
                        }
                    }
                    
                    // navigerar till hemskärmen
                    transitionToHome()
                    
                }
            }
        }
        
        func showError(_ message:String) {
            errorLabel.text = message
            errorLabel.alpha = 1
        }
        
        func transitionToHome() {
            
            performSegue(withIdentifier: "enterHome", sender: self)
            
        }
    }
}

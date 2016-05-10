//
//  GameController.swift
//  Mastermind
//
//  Created by Alex Robinson on 5/5/16.
//  Copyright © 2016 Alex Robinson. All rights reserved.
//

import UIKit

extension Array {
    mutating func shuffle() -> Array {
        var elements = self
        for index in 0..<(elements.count - 1) {
            let newIndex = Int(arc4random_uniform(UInt32(count - index))) + index
            if index != newIndex {
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
}


class GameController: UIViewController, UITextFieldDelegate {
    
    //Mark: Variables
    var round = 0
    var code = ""
    var colorPositionMatch = 0
    
    //Mark: Outlets
    @IBOutlet weak var triesLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var userGuessTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userGuessTextField.delegate = self
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func startNewGame() {
        userGuessTextField.text = ""
        code = generateCode()
        codeLabel.text = code
        round = 0
        updateTries()
    }
    
    func updateTries() {
        round += 1
        colorPositionMatch = 0
        triesLabel.text = String(round)
    }
    
    func generateCode() -> String {
        var colors = ["R", "G", "B", "Y"]
        let shuffledColors = colors.shuffle().joinWithSeparator("")
        return shuffledColors
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let userGuess = userGuessTextField.text
        
        if acceptableUserGuess(userGuess!) {
            if compareGuess(userGuess!) {
                youWon()
            } else {
                guessAgain()
            }
        } else {
            invalidInput(userGuess!)
        }
    }
    
    func acceptableUserGuess(userGuess:String) -> Bool {
        for char in userGuess.lowercaseString.characters {
            if (!(char == "r" || char == "g" || char == "y" || char == "b")) {
                return false
            } else if userGuess.characters.count != 4 {
                return false
            }
        }
        return true
    }
    
    func invalidInput(userGuess:String) {
        let message = "Your guess of '\(userGuess)' is not valid. Please enter only 4 characters consisting of 'R', 'G', 'Y' & 'B'"
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .Alert)
        let closeButton = UIAlertAction(title: "Close", style: .Default, handler: nil)
        alert.addAction(closeButton)
        
        presentViewController(alert, animated: true, completion: nil)
        userGuessTextField.text = ""
    }
    
    func compareGuess(userGuess:String) -> Bool {
        if userGuess == code {
         return true
        } else {
            countColorPosition(userGuess)
            return false
        }
        
    }
    
    func countColorPosition(userGuess:String) {
        for index in code.characters.indices {
            if code[index] == userGuess[index] {
                colorPositionMatch += 1
            }
        }
    }
    
    func youWon() {
        let message = "You da best! You guessed the code! Can you do it again?!"
        let alert = UIAlertController(title: "You Won!", message: message, preferredStyle: .Alert)
        let closeButton = UIAlertAction(title: "Close", style: .Default, handler: nil)
        
        alert.addAction(closeButton)
        
        presentViewController(alert, animated: true, completion: nil)
        startNewGame()
    }
    
    func guessAgain() {
        if round != 10 {
            let message = "Womp womp, guess again! You have \(colorPositionMatch) of the correct colors"
            let alert = UIAlertController(title: "You wrong, you wrong!", message: message, preferredStyle: .Alert)
            let closeButton = UIAlertAction(title: "Close", style: .Default, handler: nil)
            
            alert.addAction(closeButton)
            
            presentViewController(alert, animated: true, completion: nil)
            userGuessTextField.text = ""
            updateTries()
        } else {
            let message = "You couldn't guess the code! You lose!"
            let alert = UIAlertController(title: "You lose!", message: message, preferredStyle: .Alert)
            let closeButton = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
            
            alert.addAction(closeButton)
            presentViewController(alert, animated: true, completion: nil)
            startNewGame()
        }
        
        
    }
    
    
    //    @IBAction func submitGuess(sender: UIButton) {
    //
    //    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

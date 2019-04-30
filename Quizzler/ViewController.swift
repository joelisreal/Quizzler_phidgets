//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    let buttonArray = [DigitalInput(), DigitalInput()]
    let ledArray = [DigitalOutput(), DigitalOutput()]
    
    func attach_handler(sender: Phidget) {
        do {
            let hubPort = try sender.getHubPort()
            if (hubPort == 1) {
                print("Button 1 Attached")
            }
            else if (hubPort == 2) {
                print("Button 2 Attached")
            }
            else if (hubPort == 3) {
                print("Led 3 Attached")
            }
            else if (hubPort == 4) {
                print("Led 4 Atached")
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //catch other errors here
        }
    }
    

            //checkAnswer()
            //questionNumber += 1
            //nextQuestion()
    
    
    func state_change(sender: DigitalInput, state: Bool) {
        do {
            
        
            if( state == true) {
                if (sender === buttonArray[0]) {
                    print("Button 1 Pressed")
                    pickedAnswer = true
                    try ledArray[0].setState(true)
                    //try checkAnswer()
                    
                    
                } else if (sender === buttonArray[1]) {
                        print("Button 2 Pressed")
                        pickedAnswer = false
                        try ledArray[1].setState(true)
                        //try checkAnswer()
                }
                checkAnswer()
                questionNumber += 1
                //updateUI()
                //nextQuestion()
                
            }
            else {
                    if (sender === buttonArray[0]) {
                    print("Button 1 Not Pressed")
                    try ledArray[0].setState(false)
                    }

                    else if (sender === buttonArray[1]){
                    print("Button 2 Not Pressed")
                    try ledArray[1].setState(false)
                    }
                }
        }
        catch let err as PhidgetError {
            print("phidget Error " + err.description)
        } catch {
            //catch other errors here
        }
        
    }
    
    func answerPressed() {
//        do{
//            if button2.stateChange == true {
//                if button2.state == true {
//                    pickedAnswer = false
//                }
//            }
//            else if button1.stateChange == true {
//                if button1.state == true {
//                    pickedAnswer = true
//                }
//            }
//            checkAnswer()
//            questionNumber += 1
//            nextQuestion()
//        } catch {
//
//                }
//        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextQuestion()

        do{
            //enable server discovery
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address objects
            
            
            for i in 0..<buttonArray.count {
                try buttonArray[i].setDeviceSerialNumber(528025)
                try buttonArray[i].setHubPort(i+1)
                try buttonArray[i].setIsHubPortDevice(true)
                let _ = buttonArray[i].stateChange.addHandler(state_change)
                let _ = buttonArray[i].stateChange.addHandler(state_change)
                let _ = buttonArray[i].attach.addHandler(attach_handler)

                try buttonArray[i].open()
            }

            
            //add attach handlers

            
            //add state change handlers

            
            
            
            //open objects

            for i in 0..<ledArray.count {
                try ledArray[i].setDeviceSerialNumber(528025)
                try ledArray[i].setHubPort(i+3)
                try ledArray[i].setIsHubPortDevice(true)
                let _ = ledArray[i].attach.addHandler(attach_handler)
                try ledArray[i].open()
                
            }

        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //catch other errors
        }
    }

//Check if the user picked an answer and pull up the next question
    @IBAction func answerPressed(_ sender: AnyObject) {
       // if sender.tag == 1 {
         //   pickedAnswer = true
        //}
        //else if sender.tag == 2 {
         //   pickedAnswer = false
        //}


        //checkAnswer()

        //questionNumber += 1

        //nextQuestion()


    }

    
    //update progress bar/label and score label
    func updateUI() {
      
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / 13 "
        
        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber + 1)
        //print(questionNumber)
        print(progressBar.frame.size.width)
    }
    

    func nextQuestion() {
        //If the questions aren't over 12, pull up the next one otherwise pull up an alert button
        if questionNumber <= 12 {
            
            questionLabel.text = allQuestions.list[questionNumber].questionText
            
            updateUI()
            
        }
        else {
            let alert = UIAlertController(title: "End of Quiz", message: "Do you want to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in self.startOver()
                })
            //Add the restart button to the UIAlertController
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil )
        }
    }
    
    
    func checkAnswer() {
        print(questionNumber)
        print(pickedAnswer)
        let correctAnswer = allQuestions.list[questionNumber].answer
        print(correctAnswer)
        //if the correct answer was picked then show 'correct' and increase score by 1 otherwise show 'wrong'
        if correctAnswer == pickedAnswer {
            
            ProgressHUD.showSuccess("Correct")
            
            score += 1
        }
        else {
            ProgressHUD.showError("Wrong!")
        }
    }
    
    //Start over from question 1 if the user restarts
    func startOver() {
        questionNumber = 0
        score = 0
        nextQuestion()
    }
    

    
}

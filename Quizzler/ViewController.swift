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
    
    let button0 = DigitalInput()
    let button1 = DigitalInput()
    let ledArray = [DigitalOutput(), DigitalOutput()]
    
    func attach_handler(sender: Phidget) {
        do{
            if(try sender.getHubPort() == 1){
                print("Button 0 Attached")
            }
            else if (try sender.getHubPort() == 2){
                print("Button 1 Attached")
            }
            else if (try sender.getHubPort() == 3) {
                print("Led 0 attached")
            }
            else if (try sender.getHubPort() == 4) {
                print("Led 1 attached")
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    func state_change_button0(sender: DigitalInput, state: Bool) {
        do {
            if(state == true) {
                print("Button 0 Pressed")
                pickedAnswer = true
                checkAnswer()
                questionNumber += 1
                nextQuestion()
            }
            else {
                print("Button 0 Not Pressed")
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    func state_change_button1(sender: DigitalInput, state: Bool) {
        do {
            if(state == true) {
                print("Button 1 Pressed")
                pickedAnswer = false
                checkAnswer()
                questionNumber += 1
                nextQuestion()
            }
            else {
                print("Button 1 Not Pressed")
            }
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    

    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextQuestion()

        do{
            //enable server discovery
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address objects
            try button0.setDeviceSerialNumber(528025)
            try button0.setHubPort(1)
            try button0.setIsHubPortDevice(true)
            
            try button1.setDeviceSerialNumber(528025)
            try button1.setHubPort(2)
            try button1.setIsHubPortDevice(true)
            
            //add attach handlers
            let _ = button0.attach.addHandler(attach_handler)
            let _ = button1.attach.addHandler(attach_handler)
            
            //add state change handlers
            let _ = button0.stateChange.addHandler(state_change_button0)
            let _ = button1.stateChange.addHandler(state_change_button1)
            
            //open objects
            try button0.open()
            try button1.open()


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


    
    //update progress bar/label and score label
    func updateUI() {
        DispatchQueue.main.async {
        self.scoreLabel.text = "Score: \(self.score)"
        self.progressLabel.text = "\(self.questionNumber + 1) / 13 "
        
        self.progressBar.frame.size.width = (self.view.frame.size.width / 13) * CGFloat(self.questionNumber + 1)
        //print(questionNumber)
        print(self.progressBar.frame.size.width)
    }
    }
    

    func nextQuestion() {
        //If the questions aren't over 12, pull up the next one otherwise pull up an alert button
        DispatchQueue.main.async {
        if self.questionNumber <= 12 {
            
            self.questionLabel.text = self.allQuestions.list[self.questionNumber].questionText
            
            self.updateUI()
            
        }
        else {

            self.startOver()
        }
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

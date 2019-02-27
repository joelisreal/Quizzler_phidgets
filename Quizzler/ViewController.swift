//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextQuestion()
    }

//Check if the user picked the right answer and pull up the next question
    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag == 1 {
            pickedAnswer = true
        }
        else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer()
        
        questionNumber += 1
       
        nextQuestion()
        
        
    }
    
    //update progress bar/label and score label
    func updateUI() {
      
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / 13 "
        
        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber + 1)
        
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
        
        let correctAnswer = allQuestions.list[questionNumber].answer
        
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

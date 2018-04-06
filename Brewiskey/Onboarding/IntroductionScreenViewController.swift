//
//  IntroductionScreenViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

protocol BaseOnboardingScreenDelegate{
    func signupWithEmail()
    func signupWithFacebook()
    func loginUser()
}

class IntroductionScreenViewController: UIViewController {
    
    @IBOutlet weak var onboardingView: UIView!
    var index = 0
    var kNumberOfOnboardingScreens = 4
    var kRequiredNumberToTapForward = CGFloat(0.3)
    
    override func viewDidLoad() {
        loadOnboardingScreens()
        setupTapGesture()
        setupSwipeGesture()
    }
    
    private func loadOnboardingScreens(){
        guard let objects = Bundle.main.loadNibNamed("OnboardingView\(self.index)", owner: nil, options: [:]) else {
            return
        }
        guard let view = objects[0] as? BaseOnboardingView else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.navigateUserDelegate = self
        
        for subview in self.onboardingView.subviews {
            subview.removeFromSuperview()
        }
        self.onboardingView.addSubview(view)
        
        let views = [ //necessary to configure the view's constraint's..
            "onboardingView" : view
        ]
        self.onboardingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[onboardingView]|", options: [], metrics: nil, views: views))
        self.onboardingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[onboardingView]|", options: [], metrics: nil, views: views))
    }
    
    private func setupTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            let tapLocation = sender.location(in: self.view)
            
            if tapLocation.x > self.view.frame.size.width * kRequiredNumberToTapForward {
                guard index < kNumberOfOnboardingScreens else {
                    return
                }
                index += 1
            } else { //tapped backwards
                guard index > 0 else {
                    return
                }
                index -= 1
            }
            self.loadOnboardingScreens()
        }
    }
    
    private func setupSwipeGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            if sender.direction == UISwipeGestureRecognizerDirection.left{
                guard index < kNumberOfOnboardingScreens else {
                    return
                }
                index += 1
            } else if sender.direction == UISwipeGestureRecognizerDirection.right{
                guard index > 0 else {
                    return
                }
                index -= 1
            }
            self.loadOnboardingScreens()
        }
    }
    
}

extension IntroductionScreenViewController: BaseOnboardingScreenDelegate {
    func signupWithEmail() {
        performSegue(withIdentifier: "signUpIdentifier", sender: self)
    }
    
    func signupWithFacebook() {
        
    }
    
    func loginUser() {
        performSegue(withIdentifier: "loginIdentifier", sender: nil)  
    }
    
}

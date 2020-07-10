//
//  ViewController.swift
//  Sticky Notes
//
//  Created by Omeesh Sharma on 10/07/20.
//  Copyright © 2020 Omeesh Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var bgViews: [UIView]!
    @IBOutlet weak var stickyView: UIView!
    @IBOutlet weak var stickyHeight: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    var lastLocation = CGPoint(x: 0, y: 0)
    
    
    //MARK:- ACTIVITY CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rotateViews()
        
        //Add Pan Gesture
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.detectPan(_:)))
        self.stickyView.addGestureRecognizer(panRecognizer)
        
        //Add Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.detectPinch(_:)))
        self.stickyView.addGestureRecognizer(pinchGesture)
        
        //Load Last Saved Poistion
        self.loadLastPosition()
    }
    
    ///Rotate background views
    func rotateViews(){
        var degrees : CGFloat = -5
        for bgView in self.bgViews{
            let radians = CGFloat(__sinpi(degrees.native/180.0))
            bgView.transform = .init(rotationAngle: radians)
            degrees -= 5
        }
    }
    
    ///Get Last position
    func loadLastPosition(){
        if let location = CoreContext.shared.lastLocation{
            let xPoint : CGFloat = (location.value(forKey: "x") as? CGFloat) ?? self.stickyView.center.x
            let yPoint : CGFloat = (location.value(forKey: "y") as? CGFloat) ?? self.stickyView.center.y
            let height : CGFloat = (location.value(forKey: "height")as? CGFloat)  ?? self.stickyHeight.constant
            self.stickyHeight.constant = CGFloat(height)
            
            DispatchQueue.main.async {
                self.stickyView.center = .init(x: xPoint, y: yPoint)
                self.bgViews.forEach({$0.center = self.stickyView.center})
            }
        }        
    }
    
    ///Save Location
    func saveLocation(){
        CoreContext.shared.saveLocation(self.stickyView.center, self.stickyHeight.constant)
    }
    
}

extension ViewController{
    
    //MARK:- Gesture Actions
    
    //Sticky View start Dragging
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Remember original location
        self.lastLocation = self.stickyView.center
    }
    
    //Sticky View Dragged
    @objc func detectPan(_ sender: UIPanGestureRecognizer){
        let translation  = sender.translation(in: self.view)
        self.stickyView.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        self.bgViews.forEach({$0.center = self.stickyView.center})
        
        if sender.state == .ended{
            self.saveLocation()
        }
    }
    
    //Sticky View pinched
    @objc func detectPinch(_ sender: UIPinchGestureRecognizer){
        //Increase Decrease height according to pinch velocity
        self.stickyHeight.constant += sender.velocity
        
        if sender.state == .ended{
            self.saveLocation()
        }
    }
    
    
}

//
//  ViewController.swift
//  UIDynamics
//
//  Created by Julio Brazil on 16/05/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    
    var hits = 0
    
    @IBOutlet weak var cube: UIView!
    @IBOutlet weak var barrier: UIView!
    @IBOutlet weak var backgroundimage: UIImageView!
    @IBOutlet weak var score: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        
        self.score.text = "\(hits)"
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundimage.bounds
        backgroundimage.addSubview(blurEffectView)
        
        let vibracyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
        let vibracyEffectView = UIVisualEffectView(effect: vibracyEffect)
        vibracyEffectView.frame = backgroundimage.bounds
        backgroundimage.addSubview(vibracyEffectView)
        
        self.animator = UIDynamicAnimator(referenceView: view)
        self.gravity = UIGravityBehavior(items: [cube])
        self.animator.addBehavior(self.gravity)
        
        self.collision = UICollisionBehavior(items: [cube])
        self.collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collision)
        
        self.collision.collisionDelegate = self
        
        let itemBehaviour = UIDynamicItemBehavior(items: [cube])
        //itemBehaviour.elasticity = 1.1
        animator.addBehavior(itemBehaviour)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first!
        snap = UISnapBehavior(item: cube, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animator.removeBehavior(snap)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        animator.removeBehavior(snap)
        
        let touch = touches.first!
        snap = UISnapBehavior(item: cube, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }

    //Mark: - Colision Delegate
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        if let _ = identifier {
            self.hits += 1
            self.score.text = "\(hits)"
        }
        
        let collidingView = item as! UIView
        collidingView.backgroundColor = #colorLiteral(red: 0.9153869748, green: 0.1759856343, blue: 0.1781242192, alpha: 1)
        UIView.animate(withDuration: 0.5) {
            collidingView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
}


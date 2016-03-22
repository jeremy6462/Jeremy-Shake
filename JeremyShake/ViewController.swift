//
//  ViewController.swift
//  JeremyShake
//
//  Created by Jeremy Kelleher on 2/14/16.
//  Copyright © 2016 JKProductions. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate /*Not sure why I need this*/ {

    @IBOutlet weak var imageTaken: UIImageView!
    @IBOutlet weak var jeremyHead: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    var currentJeremyHead = 0
    
    @IBOutlet weak var firstInstruction: UILabel!
    @IBOutlet weak var secondInstruction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.image = UIImage(named: "background")
        blurBackground()
        
        firstInstruction.layer.cornerRadius = 10
        secondInstruction.layer.cornerRadius = 10

        self.becomeFirstResponder()
    }

    // MARK: - Set up base image
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo with Camera", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        let chooseImageAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(chooseImageAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        firstInstruction.hidden = true
        secondInstruction.hidden = true
        
        imageTaken.image = image
        imageTaken.hidden = false
        
        background.image = image
        blurBackground()
        background.hidden = false
        
        saveButton.hidden = false
        cancelButton.hidden = false
    }
    
    func blurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.view.frame
        background.addSubview(blurredEffectView)
    }
    
    // MARK: - Respond to shakes
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if imageTaken.image == nil {
            return
        }
        if motion == UIEventSubtype.MotionShake {
            let imageName = nextJeremyHead()
            jeremyHead.image = UIImage(named: imageName)
            jeremyHead.hidden = false
        }
    }
    
    func nextJeremyHead() -> String {
        if (currentJeremyHead >= 21) {
            currentJeremyHead = 1
        } else if (currentJeremyHead < 21 && currentJeremyHead > 0) {
            currentJeremyHead += 1
        } else {
            currentJeremyHead = 1
        }
        return "jeremyHead\(currentJeremyHead)"
    }
    
    // MARK: - Utilities
    
    @IBAction func openShareSheet(sender: AnyObject) {

        UIGraphicsBeginImageContext(self.view.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        containerView.layer.renderInContext(context!)
        let screenImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [screenImage], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop]
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
        currentJeremyHead = 0
        
        firstInstruction.hidden = false
        secondInstruction.hidden = false
        
        imageTaken.image = nil
        imageTaken.hidden = true
        
        jeremyHead.image = nil
        jeremyHead.hidden = true
        
        background.image = UIImage(named: "background")
        blurBackground()
        background.hidden = false
        
        cancelButton.hidden = true
        saveButton.hidden = true
    }
    
}
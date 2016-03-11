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
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }

    @IBAction func chooseImage(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
        blurredEffectView.frame = background.bounds
        background.addSubview(blurredEffectView)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake {
            jeremyHead.image = UIImage(named: "JeremyHead")
            jeremyHead.hidden = false
        }
    }
    
    @IBAction func openShareSheet(sender: AnyObject) {

        UIGraphicsBeginImageContext(self.view.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        imagesView.layer.renderInContext(context!)
        let screenImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [screenImage], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop]
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }

    @IBAction func cancel(sender: AnyObject) {
        imageTaken.image = nil
        imageTaken.hidden = true
        
        jeremyHead.image = nil
        jeremyHead.hidden = true
        
        background.image = nil
        background.hidden = true
        
        cancelButton.hidden = true
        saveButton.hidden = true
    }
    
}


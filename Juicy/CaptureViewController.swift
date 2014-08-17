//
//  PostViewController.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/15/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, VLBCameraViewDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var cameraView: VLBCameraView!
    @IBOutlet weak var captureButton: UIButton!
    
    // MARK: Instance Variables
    private var capturedImage: UIImage!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // VLBCameraView Set Delegate
        self.cameraView.delegate = self
        
        // Setup Post Button
        self.captureButton.backgroundColor = UIColor(red:0.24, green:0.78, blue:0.29, alpha:1)
        
        // Add Post Button Top Border
        var buttonBorder = UIView(frame: CGRectMake(0, 0, self.captureButton.frame.size.width, 3))
        buttonBorder.backgroundColor = UIColor(white: 0, alpha: 0.08)
        self.captureButton.addSubview(buttonBorder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraView.awakeFromNib()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let viewController:PostViewController = segue.destinationViewController as PostViewController
        viewController.capturedImage = self.capturedImage
    }
    
    // MARK: IBActions
    @IBAction func cancelCapture(sender: UIBarButtonItem) {
        self.navigationController.popViewControllerAnimated(false)
    }
    
    @IBAction func captureDown(sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.2, green:0.64, blue:0.22, alpha:1)
    }
    
    @IBAction func captureTouchInside(sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.24, green:0.78, blue:0.29, alpha:1)
        self.cameraView.takePicture()
    }
    
    @IBAction func toggleCamera(sender: UIBarButtonItem) {
        self.cameraView.toggleCamera()
    }
    
    // MARK: VLBCameraView Methods
    func cameraView(cameraView: VLBCameraView!, didFinishTakingPicture image: UIImage!, withInfo info: [NSObject : AnyObject]!, meta: [NSObject : AnyObject]!) {
        self.capturedImage = image;
        self.performSegueWithIdentifier("postSegue", sender: self)
    }
    
    func cameraView(cameraView: VLBCameraView!, didErrorOnTakePicture error: NSError!) {
        UIAlertView(title: "Capture Image", message: "Sorry! We failed to your image.", delegate: nil, cancelButtonTitle: "Ok").show()
        self.cameraView.retakePicture()
    }
}
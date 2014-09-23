//
//  TermsViewController.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/28/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

class TermsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Instance Variables
    private var url: NSURL!
    private var currentUser = User.current()
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Seturl WebView Url
        Settings.current { (settings) -> Void in
            self.url = NSURL(string: "http://\(settings.host)/terms")
            self.webView.loadRequest(NSURLRequest(URL: self.url))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
       super.viewWillAppear(animated)
        
        // Configure Status Bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // Configure Navigation Bar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 18)
        ]
    }
    
    // MARK: IBActions
    @IBAction func termsCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(false)
        User.logout()
    }
    
    @IBAction func termsAccepts(sender: UIBarButtonItem) {
        if self.url != nil {
            self.currentUser.acceptedTerms()
            self.performSegueWithIdentifier("loggedInSegue", sender: self)
        }
    }
}

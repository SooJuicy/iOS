//
//  PostViewController.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/16/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

class PostViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Instance Variables
    var capturedImage: UIImage!
    private var cityLocation: String!
    private var textEditor: CHTTextView!
    private var previewImageView: UIImageView!
    private var currentUser: User = User.current()
    private var contacts: [String] = []
    private var locationManager: CLLocationManager!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Preview Image
        self.previewImageView = UIImageView(frame: self.view.frame)
        self.previewImageView.image = RBResizeImage(self.capturedImage, self.view.frame.size)
        self.previewImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.previewImageView)
        
        // Add Darkener
        var darkener = UIView(frame: self.view.frame)
        darkener.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.insertSubview(darkener, aboveSubview: self.previewImageView)
        
        // Add Text Editor
        self.textEditor = CHTTextView(frame: self.view.frame)
        self.textEditor.delegate = self
        self.textEditor.frame.size.width -= 40
        self.textEditor.frame.origin.x += 20
        self.textEditor.frame.origin.y += 110
        self.textEditor.scrollEnabled = false
        self.textEditor.placeholder = "Tell us what's juicy!"
        self.textEditor.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        self.textEditor.textColor = UIColor.whiteColor()
        self.textEditor.textAlignment = NSTextAlignment.Center
        self.textEditor.backgroundColor = UIColor.clearColor()
        self.textEditor.layer.shadowColor = UIColor(white: 0, alpha: 0.2).CGColor
        self.textEditor.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.textEditor.layer.shadowOpacity = 1
        self.textEditor.layer.shadowRadius = 0
        self.textEditor.becomeFirstResponder()
        self.view.insertSubview(self.textEditor, aboveSubview: darkener)
        
        // Create Location Manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get Current Location
        self.locationManager.startUpdatingLocation()
        
        // Get Friends List
        self.currentUser.getFriendsList(nil)
        
        // Get Contact List
        var contacts = Contacts()
        contacts.getContacts { (contacts) -> Void in
            for contact in contacts {
                self.contacts.append(contact.name)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Configure Navigation Bar
        self.navigationItem.title = "0/75"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 22)
        ]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)
        ], forState: UIControlState.Normal)
    }
    
    // MARK: IBActions
    @IBAction func canelPost(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func createPost(sender: UIBarButtonItem) {
        var content: [Dictionary<String, AnyObject>] = []
        var aboutUsers: [User] = []
        let editorText: NSString = self.textEditor.text
        var friends = self.detectFriendsInMessage(editorText)
        let imageSize = CGSize(width: self.capturedImage.size.width/2, height: self.capturedImage.size.width/2)
        
        if editorText.length != 0 {
            if friends.isEmpty {
                content.append([
                    "message": editorText,
                    "color": false
                ])
            } else {
                for (index, friend) in enumerate(friends) {
                    var endRange: NSRange;
                    let range = friend["range"] as NSRange
                    let endLocation = range.location + range.length
                    
                    if friend["user"] is User {
                        aboutUsers.append(friend["user"] as User)
                    }
                    
                    if index == 0 && range.location != 0 {
                        content.append([
                            "message": editorText.substringWithRange(_NSRange(location: 0, length: range.location)),
                            "color": false
                        ])
                    }
                    
                    content.append([
                        "message": editorText.substringWithRange(range),
                        "color": true
                    ])
                    
                    if index == (friends.count - 1) {
                        endRange = _NSRange(location: endLocation, length: editorText.length - endLocation)
                    } else {
                        endRange = _NSRange(location: endLocation, length: (friends[index + 1]["range"] as NSRange).location - endLocation)
                    }
                
                    if endRange.length > 0 {
                        content.append([
                            "message": editorText.substringWithRange(endRange),
                            "color": false
                        ])
                    }
                }
            }
            
            self.navigationController?.popToViewController(self.navigationController?.viewControllers[1] as UIViewController, animated: false)
            Post.create(content, aboutUsers: aboutUsers, image: RBResizeImage(self.capturedImage, imageSize),
                        creator: self.currentUser, location: self.cityLocation)
        }
    }
    
    // MARK: Instance Methods
    func detectFriendsInMessage(text: String) -> [AnyObject] {
        let lowerText = NSString(string: text.lowercaseString)
        var friends: [AnyObject] = []
        var ranges = NSMutableArray()
        
        // Search By Registered Users
        if self.currentUser.friendsList != nil {
            for friend in self.currentUser.friendsList {
                let range = lowerText.rangeOfString(friend.name.lowercaseString)
                
                if range.location != Foundation.NSNotFound && !ranges.containsObject(range)  {
                    let length = range.location + range.length
                    
                    if (range.location == 0 || text[range.location - 1] == " ") && (length == lowerText.length || text[length] == " " ||  text[length] == ".") {
                        friends.append([ "user": friend, "range": range ])
                        ranges.addObject(range)
                    }
                }
            }
        }
        
        // Search By Contact List
        if !self.contacts.isEmpty {
            for contact in self.contacts {
                let range = lowerText.rangeOfString(contact.lowercaseString)
                
                if range.location != Foundation.NSNotFound && !ranges.containsObject(range) {
                    let length = range.location + range.length
                    
                    if (range.location == 0 || text[range.location - 1] == " ") && (length == lowerText.length || text[length] == " " || text[length] == ".") {
                        friends.append([ "range": range ])
                        ranges.addObject(range)
                    }
                }
            }
        }
        
        return friends
    }
    
    // MARK: CoreLocation Methods
    // This delegate is called when the app successfully finds your current location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last as CLLocation, completionHandler: { (placeMarks: [AnyObject]!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if !placeMarks.isEmpty {
                    var placeMark = placeMarks[0] as CLPlacemark
                    self.cityLocation = placeMark.locality
                }
            })
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFinishDeferredUpdatesWithError error: NSError!) {
        println(error)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    // MARK: UITextView Methods
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        return textView.text.utf16Count + (text.utf16Count - range.length) <= 75;
    }
    
    func textViewDidChange(textView: UITextView!) {
        var textColor = UIColor.whiteColor()
        var mutalableText = NSMutableAttributedString(attributedString: textView.attributedText)
        let friends = self.detectFriendsInMessage(textView.text)
        
        mutalableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, mutalableText.length))
        
        for friend in friends {
            let range = friend["range"] as NSRange
            mutalableText.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.31, green:0.95, blue:1, alpha:1), range: range)
        }
        
        if mutalableText.length >= 65 {
            textColor = UIColor(red:0.95, green:0.24, blue:0.31, alpha:1)
        } else if mutalableText.length >= 55 {
            textColor = UIColor(red:1, green:0.6, blue:0, alpha:1)
        }
        
        textView.attributedText = mutalableText
        self.navigationItem.title = "\(mutalableText.length)/75"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 22)
        ]
    }
}

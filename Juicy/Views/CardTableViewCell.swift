//
//  CardTableViewCell.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/29/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

class CardTableViewCell: UITableViewCell {
    
    // MARK: Instance Variables
    private var post: Post!
    private var backgroundImageView: UIImageView!
    private var separator: UIView!
    private var content: UILabel!
    private var location: UILabel!
    private var shares: UILabel!
    private var likes: UILabel!
    private var locationImageView: UIImageView!
    private var sharesImageView: UIImageView!
    private var likesImageView: UIImageView!
    private var containerView: UIView!
    private var darkener: UIView!
    private let duration: NSTimeInterval = 0.2
    private let delay: NSTimeInterval = 0
    
    // MARK: Convience Constructor
    convenience init(reuseIdentifier: String!, width: CGFloat, height: CGFloat) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        // Track Event
        Track.event("Card Table View: Created")
        
        // Configure Cell
        self.frame = CGRectMake(0, self.frame.origin.y, width, height)
        self.clipsToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.blackColor()
        
        // Create Background Image
        self.backgroundImageView = UIImageView(frame: self.frame)
        self.backgroundView = self.backgroundImageView
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // Create Separator
        self.separator = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 3))
        self.separator.backgroundColor = UIColor(white: 1, alpha: 0.15)
        self.addSubview(self.separator)
        
        // Create Darkener
        self.darkener = UIView(frame: self.frame)
        self.darkener.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(self.darkener)
        
        // Create Container View
        self.containerView = UIView(frame: self.frame)
        self.insertSubview(self.containerView, aboveSubview: self.darkener)
        
        // Create Content Label
        self.content = UILabel(frame: CGRectMake(10, 10, self.frame.width - 20, self.frame.height - 50))
        self.content.textAlignment = NSTextAlignment.Center
        self.content.textColor = UIColor.whiteColor()
        self.content.shadowColor = UIColor(white: 0, alpha: 0.2)
        self.content.shadowOffset = CGSize(width: 0, height: 2)
        self.content.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        self.content.numberOfLines = 0
        self.content.adjustsFontSizeToFitWidth = true
        self.containerView.addSubview(self.content)
        
        // Y Value For Frame
        var imageY = self.frame.height - 35
        var labelY = self.frame.height - 35
        
        // Create Location Text
        var locationImage =  UIImage(named: "Location")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.locationImageView = UIImageView(image: locationImage)
        self.containerView.addSubview(locationImageView)
        
        self.locationImageView.tintColor = UIColor.whiteColor()
        self.locationImageView.frame = CGRectMake(10, imageY, 20, 20)
        self.locationImageView.layer.shadowColor = UIColor.blackColor().CGColor;
        self.locationImageView.layer.shadowOffset = CGSizeMake(0, 1);
        self.locationImageView.layer.shadowOpacity = 0.2;
        self.locationImageView.layer.shadowRadius = 1.0;
        self.locationImageView.clipsToBounds = false;
        
        self.location = UILabel(frame: CGRectMake(38, labelY, 115, 20))
        self.location.textAlignment = NSTextAlignment.Left
        self.location.textColor = UIColor.whiteColor()
        self.location.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.location.shadowColor = UIColor(white: 0, alpha: 0.2)
        self.location.shadowOffset = CGSize(width: 0, height: 2)
        self.containerView.addSubview(self.location)
        
        // Create Like Text
        self.likes = UILabel(frame: CGRectMake(self.frame.width - 46, labelY, 36, 20))
        self.likes.textAlignment = NSTextAlignment.Left
        self.likes.textColor = UIColor.whiteColor()
        self.likes.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.likes.shadowColor = UIColor(white: 0, alpha: 0.2)
        self.likes.shadowOffset = CGSize(width: 0, height: 2)
        self.containerView.addSubview(self.likes)
        
        var likesImage =  UIImage(named: "Heart")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.likesImageView = UIImageView(image: likesImage)
        self.containerView.addSubview(likesImageView)
        
        self.likesImageView.tintColor = UIColor.whiteColor()
        self.likesImageView.frame = CGRectMake(self.frame.width - 74, imageY, 20, 20)
        self.likesImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.likesImageView.layer.shadowOffset = CGSizeMake(0, 1)
        self.likesImageView.layer.shadowOpacity = 0.2
        self.likesImageView.layer.shadowRadius = 1.0
        self.likesImageView.clipsToBounds = false
        
        // Create Share Text
        self.shares = UILabel(frame: CGRectMake(self.frame.width - 118, labelY, 36, 20))
        self.shares.textAlignment = NSTextAlignment.Left
        self.shares.textColor = UIColor.whiteColor()
        self.shares.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.shares.shadowColor = UIColor(white: 0, alpha: 0.2)
        self.shares.shadowOffset = CGSize(width: 0, height: 2)
        self.containerView.addSubview(self.shares)
        
        var sharesImage =  UIImage(named: "Shared")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.sharesImageView = UIImageView(image: sharesImage)
        self.containerView.addSubview(sharesImageView)
        
        self.sharesImageView.tintColor = UIColor.whiteColor()
        self.sharesImageView.frame = CGRectMake(self.frame.width - 146, imageY, 20, 20)
        self.sharesImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.sharesImageView.layer.shadowOffset = CGSizeMake(0, 1)
        self.sharesImageView.layer.shadowOpacity = 0.2
        self.sharesImageView.layer.shadowRadius = 1.0
        self.sharesImageView.clipsToBounds = false

        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandle:"))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Gesture Handlers
    @IBAction func tapHandle(gesture: UIPanGestureRecognizer) {
        if self.post.image != nil {
            // Track Event
            Track.event("Card Table View: Tab Gesture")
            
            // Toggle Content
            UIView.animateWithDuration(self.duration, delay: self.delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.darkener.alpha = self.post.darkenerAlpha - self.darkener.alpha
                self.containerView.alpha = self.post.darkenerAlpha - self.containerView.alpha
            }, completion: nil)
        }
    }
    
    // MARK: Instance Methods
    func setSeparator(show: Bool) {
        self.separator.hidden = !show
    }
    
    func setContent(post: Post, standing: Int!) {
        self.post = post
        self.shares.text = post.shares.abbreviate()
        self.likes.text = post.likes.abbreviate()
        
        if post.location != nil {
            self.location.text = post.location
        } else {
            self.location.text = "Anonymous"
        }
        
        if post.juicy as Bool {
            self.likesImageView.tintColor = UIColor(red:0.96, green:0.33, blue:0.24, alpha:1)
        } else {
            self.likesImageView.tintColor = UIColor.whiteColor()
        }
        
        var contentAttr = NSMutableAttributedString()
        
        if standing != nil {
            if let font = UIFont(name: "HelveticaNeue-Bold", size: 36) {
                var standingAttrString = NSMutableAttributedString(string: "#\(standing)\n")
                standingAttrString.addAttribute(NSFontAttributeName,
                    value: font, range: NSMakeRange(0, standingAttrString.length))
                contentAttr.appendAttributedString(standingAttrString)
            }
        }
        
        for block in post.content as [AnyObject] {
            let message: String? = block["message"] as String!
            
            if message != nil {
                var blockAttrString = NSMutableAttributedString(string: message!)
                
                if block["color"] as Bool {
                    blockAttrString.addAttribute(NSForegroundColorAttributeName,
                        value: CardView.Defaults().personColor, range: NSMakeRange(0, blockAttrString.length))
                }
                
                contentAttr.appendAttributedString(blockAttrString)
            }
        }
        
        // Add Background Color
        if post.background != nil {
            self.backgroundColor = self.post.background
        } else {
            self.backgroundColor = UIColor.blackColor()
        }
        
        self.containerView.alpha = 1
        self.content.attributedText = contentAttr
        self.backgroundImageView.alpha = 0
        self.backgroundImageView.image = nil
        self.darkener.alpha = self.post.darkenerAlpha
        
        if post.image != nil {
            post.getImage({ (image) -> Void in
                UIView.animateWithDuration(self.duration, delay: self.delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.backgroundImageView.alpha = 1
                    self.backgroundImageView.image = image
                }, completion: nil)
            })
        }
    }
}

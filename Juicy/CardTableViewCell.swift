//
//  CardTableViewCell.swift
//  Juicy
//
//  Created by Brian Vallelunga on 8/29/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

class CardTableViewCell: UITableViewCell {
    
    // MARK: Instance Variables
    var backgroundImageView: UIImageView!
    var content: UILabel!
    
    // MARK: Private Instance Variables
    private var darkener: UIView!
    private let duration: NSTimeInterval = 0.2
    private let delay: NSTimeInterval = 0
    
    // Convience Constructor
    convenience init(reuseIdentifier: String!) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, 250)
        self.clipsToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.backgroundImageView = UIImageView()
        self.backgroundView = self.backgroundImageView
        self.backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.darkener = UIView(frame: self.frame)
        self.darkener.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.5)
        self.addSubview(self.darkener)
        
        self.content = UILabel(frame: CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20))
        self.content.textAlignment = NSTextAlignment.Center
        self.content.textColor = UIColor.whiteColor()
        self.content.shadowColor = UIColor(white: 0, alpha: 0.2)
        self.content.shadowOffset = CGSize(width: 0, height: 2)
        self.content.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        self.content.numberOfLines = 6
        self.content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.insertSubview(self.content, aboveSubview: darkener)
        
        var buttonBorder = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 3))
        buttonBorder.backgroundColor = UIColor(white: 1, alpha: 0.15)
        self.insertSubview(buttonBorder, aboveSubview: self.content)

        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandle:"))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Gesture Handlers
    @IBAction func tapHandle(gesture: UIPanGestureRecognizer) {
        UIView.animateWithDuration(self.duration, delay: self.delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.content.alpha = 1 - self.content.alpha
            self.darkener.alpha = 1 - self.darkener.alpha
        }, completion: nil)
    }

}

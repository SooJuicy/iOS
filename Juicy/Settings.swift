//
//  Settings.swift
//  Juicy
//
//  Created by Brian Vallelunga on 9/22/14.
//  Copyright (c) 2014 Brian Vallelunga. All rights reserved.
//

class Settings: NSObject {
    
    // MARK: Instance Variables
    var version: String!
    var host: String!
    var abDefault: String!
    var abTesters: [String]!
    var abTesting: Bool!
    var backgrounds: [String: [CGFloat]]!
    var parse: PFConfig!
    
    // MARK: Convenience Methods
    convenience init(_ settings: PFConfig) {
        self.init()
        
        self.version = settings["version"] as String
        self.host = settings["host"] as String
        self.abDefault = settings["abDefault"] as String
        self.abTesters = settings["abTesters"] as [String]
        self.abTesting = settings["abTesting"] as Bool
        self.backgrounds = settings["backgrounds"] as [String: [CGFloat]]
        self.parse = settings
    }
    
    // MARK: Class Methods
    class func current(callback: (settings: Settings) -> Void) {
        PFConfig.getConfigInBackgroundWithBlock { (config: PFConfig!, error: NSError!) -> Void in
            if error == nil && config != nil {
                callback(settings: Settings(config))
            } else if var config = PFConfig.currentConfig() {
                callback(settings: Settings(config))
            }
        }
    }
}

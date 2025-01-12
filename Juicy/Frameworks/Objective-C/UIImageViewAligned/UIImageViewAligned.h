//
//  UIImageViewAligned.h
//  awards
//
//  Created by Andrei Stanescu on 7/29/13.
//  Copyright (c) 2013 Mind Treat Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UIImageViewAlignmentMaskCenter = 0,
    
    UIImageViewAlignmentMaskLeft   = 1,
    UIImageViewAlignmentMaskRight  = 2,
    UIImageViewAlignmentMaskTop    = 4,
    UIImageViewAlignmentMaskBottom = 8,
    
    UIImageViewAlignmentMaskBottomLeft = UIImageViewAlignmentMaskBottom | UIImageViewAlignmentMaskLeft,
    UIImageViewAlignmentMaskBottomRight = UIImageViewAlignmentMaskBottom | UIImageViewAlignmentMaskRight,
    UIImageViewAlignmentMaskTopLeft = UIImageViewAlignmentMaskTop | UIImageViewAlignmentMaskLeft,
    UIImageViewAlignmentMaskTopRight = UIImageViewAlignmentMaskTop | UIImageViewAlignmentMaskRight,
    
}UIImageViewAignmentMask;



@interface UIImageViewAligned : UIImageView

// This property holds the current alignment
@property (nonatomic) UIImageViewAignmentMask alignment;

// Properties needed for Interface Builder quick setup
@property (nonatomic) BOOL alignLeft;
@property (nonatomic) BOOL alignRight;
@property (nonatomic) BOOL alignTop;
@property (nonatomic) BOOL alignBottom;

// Make the UIImageView scale only up or down
// This are used only if the content mode is Scaled
@property (nonatomic) BOOL enableScaleUp;
@property (nonatomic) BOOL enableScaleDown;

// Just in case you need access to the inner image view
@property (nonatomic, readonly) UIImageView* realImageView;

@end
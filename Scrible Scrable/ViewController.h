//
//  ViewController.h
//  Scrible Scrable
//
//  Created by Nutech Systems on 12/11/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController : UIViewController{

    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwipe;

}
@property (strong, nonatomic) UIImageView *tempDrawImage;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *photoView;
@end


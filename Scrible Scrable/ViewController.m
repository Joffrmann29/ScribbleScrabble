//
//  ViewController.m
//  Scrible Scrable
//
//  Created by Nutech Systems on 12/11/14.
//  Copyright (c) 2014 Nutech Systems Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearBarButton;
@property (nonatomic) BOOL hitToolbar;

@property (nonatomic) CGFloat navBarHeight;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 100.0;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //CGRect imageFrame = [UIScreen mainScreen].bounds;
//    CGFloat navBarY =self.navigationController.navigationBar.frame.origin.y;
    _navBarHeight = self.navigationController.navigationBar.bounds.size.height;
//    imageFrame.origin.y = _navBarHeight + navBarY;
//    CGFloat toolBarHeight = _toolBar.frame.size.height;
    //imageFrame.size.height = imageFrame.size.height - 44;
    
    _photoView = [[UIImageView alloc] initWithFrame:[self imageFrame]];
    _tempDrawImage = [[UIImageView alloc] initWithFrame:[self imageFrame]];
    _mainImage = [[UIImageView alloc] initWithFrame:[self imageFrame]];
    
//    [self.view addSubview:_tempDrawImage];
//    [self.view sendSubviewToBack:_tempDrawImage];
//    [self.view addSubview:_mainImage];
//    [self.view sendSubviewToBack:_mainImage];
    [self.view addSubview:_photoView];
    //[self.view sendSubviewToBack:_photoView];
    [_photoView addSubview:_mainImage];
    [_photoView bringSubviewToFront:_mainImage];
    [_photoView addSubview:_tempDrawImage];
    [_photoView bringSubviewToFront:_tempDrawImage];
//    imageFrame.origin.y = 0;
//    [self.photoView addSubview:_mainImage];
//    [self.photoView addSubview:_tempDrawImage];

}

-(CGRect)imageFrame
{
    CGRect imageFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
    return imageFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwipe = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwipe = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(_photoView.frame.size);
//    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height)];

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha: opacity];
    UIGraphicsEndImageContext();
    
    [self.mainImage setNeedsDisplay];
    [self.tempDrawImage setNeedsDisplay];
    
    lastPoint = currentPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!mouseSwipe) {
        UIGraphicsBeginImageContext(_photoView.bounds.size);
        
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height)];
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(_photoView.bounds.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    [self.mainImage.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    [self.mainImage setNeedsDisplay];
    [self.tempDrawImage setNeedsDisplay];
}

- (IBAction)photoButton:(UIBarButtonItem *)sender
{
    //Pick an image from library
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (IBAction)saveButton:(UIBarButtonItem *)sender
{
//    CGRect temp = self.mainImage.frame;
//    temp = self.photoView.frame;
//
//    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
//    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//    [self.photoView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//    self.photoView.image = UIGraphicsGetImageFromCurrentImageContext();
//    self.mainImage.image = nil;
//    UIImage imageWithCGImage:_photoView.layer.re;
    
//    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
//
//    [self.mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.bounds.size.width, _mainImage.bounds.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
//
//    [self.photoView.image drawInRect:CGRectMake(0, 0, _photoView.bounds.size.width, _photoView.bounds.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//
//    self.photoView.image = UIGraphicsGetImageFromCurrentImageContext();
//
//    
//    UIGraphicsEndImageContext();
    [_toolBar setHidden:YES];
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //Save the Image
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertController *saved = [UIAlertController alertControllerWithTitle:nil message:@"Your image has been saved." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_toolBar setHidden:NO];
    }];
    [saved addAction:ok];
    
    
    [self presentViewController:saved animated:YES completion:nil];
    
//    self.mainImage.image = nil;
    
}

- (IBAction)toolsButton:(UIBarButtonItem *)sender
{

}

- (IBAction)undoButton:(UIBarButtonItem *)sender
{

}

- (IBAction)redoButton:(UIBarButtonItem *)sender
{
    
}

- (IBAction)clearButton:(UIBarButtonItem *)sender
{
    //Clear everything on displaying view
//    UIImageView *mainImage = _mainImage;
//    mainImage = nil;
//    mainImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.photoView.image = nil;
}

#pragma mark - Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Retrieve picked image to PhotoView layer
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    _photoView.image = photo;
    [self.view sendSubviewToBack:_photoView];
    
}


@end

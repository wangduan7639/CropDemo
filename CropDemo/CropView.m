//
//  CropView.m
//  CropDemo
//
//  Created by wangduan on 13-5-30.
//  Copyright (c) 2013年 wxcp. All rights reserved.
//

#import "CropView.h"
#import "MarkView.h"
#import "UIImage+KIAdditions.h"
#define SCROLLHEIGHT 692.0f
#define SCROLLWIDTH  557.0f
@interface CropView()
{
    CGPoint onePoint;
    CGPoint twoPoint;
    NSData *mImageData;
}
@end
@implementation CropView

@synthesize imageView = _imageView;
@synthesize image = _image;
@synthesize markView = _markView;
@synthesize imageInset = _imageInset;
@synthesize cropSize = _cropSize;
@synthesize normalSize = _normalSize;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        if (_markView == nil) {
            _markView = [[MarkView alloc]initWithFrame:self.bounds];
            [_markView setBackgroundColor:[UIColor clearColor]];
            [_markView setUserInteractionEnabled:NO];
            [self addSubview:_markView];
            [self bringSubviewToFront:_markView];
        }
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"sfsdfsdfs");
}
- (void)setImage:(UIImage *)newImage
{
    
    _image = newImage;
    
    _normalSize = newImage.size;
    normalWidth = newImage.size.width;
    NSLog(@"%lf,%lf",newImage.size.width,newImage.size.height);
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        //缩放
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        [self.imageView addGestureRecognizer:pinchGesture];
        pinchGesture.delegate = self;
        
        //旋转。
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
        [self.imageView addGestureRecognizer:rotationGesture];
        rotationGesture.delegate = self;
        [self addSubview:_imageView];
        [self sendSubviewToBack:_imageView];
    }

    [_imageView setImage:newImage];
    
    [self updateZoomScale];

}

- (void)updateZoomScale {
    
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
    
    CGFloat x = (1024 - width) / 2;
    CGFloat y = (748 - height) / 2;
    
    [_imageView setFrame:CGRectMake(x, y, width, height)];
    NSLog(@"%lf,%lf,%lf,%lf",_imageView.frame.origin.x,_imageView.frame.origin.y,_imageView.frame.size.width,_imageView.frame.size.height);
    
}

- (void)setCropSize:(CGSize)size
{
    _cropSize = size;
    
    [_markView setCropSize:_cropSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark 缩放和旋转手势的两个方法。
-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    //手势开始或改变状态。
    if(gesture.state ==UIGestureRecognizerStateBegan||gesture.state ==UIGestureRecognizerStateChanged)
    {
        //对发生手势的视图进行缩放。
        if (_imageView.frame.size.width >= 4*normalWidth ) {
            if (gesture.scale > 1.0) {
                return;
            }
        }
        else if (_imageView.frame.size.width <= normalWidth/4) {
            if (gesture.scale < 1.0) {
                return;
            }
        }
        gesture.view.transform = CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        //重置手势缩放比例。·
        [gesture setScale:1];
    }
    
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_imageView != nil) {
            [_imageView removeFromSuperview];
            _imageView = nil;
            [self setImage:_image];
        }
    }
}
-(void)rotation:(UIRotationGestureRecognizer *)gesture
{
    //手势开始或改变状态。
    if(gesture.state ==UIGestureRecognizerStateBegan||gesture.state ==UIGestureRecognizerStateChanged)
    {
        //对发生手势的视图进行旋转变换。
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        rotation = gesture.rotation;
        //重置手势旋转的角度。·
        [gesture setRotation:0];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer.view!=otherGestureRecognizer.view)
    {
        return NO;
    }
    if(gestureRecognizer.view ==_imageView)
    {
        return YES;
    }
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint mPoint = [touch locationInView:self];
        if (CGRectContainsPoint(_imageView.frame, mPoint)) {
            onePoint = mPoint;
        }
        else
        {
            onePoint = CGPointMake(-10, -10);
        }
    }
    NSLog(@"touchesBegan");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint centerPoint = _imageView.center;
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint mPoint = [touch locationInView:self];
        if (CGRectContainsPoint(_imageView.frame, mPoint)) {
            twoPoint = mPoint;
            if (onePoint.x != -10 && onePoint.y != -10) {
                if (_imageView.frame.origin.x+twoPoint.x-onePoint.x > 790 ||
                    _imageView.frame.origin.x+twoPoint.x-onePoint.x+_imageView.frame.size.width < 233 ||
                   _imageView.frame.origin.y+twoPoint.y-onePoint.y > 720 ||
                    _imageView.frame.origin.y+twoPoint.y-onePoint.y+_imageView.frame.size.height< 28) {
                    return;
                }
                _imageView.center = CGPointMake(centerPoint.x+twoPoint.x-onePoint.x, centerPoint.y+twoPoint.y-onePoint.y);
            }
             onePoint = twoPoint;
        }
    }
    NSLog(@"touchesMoved");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        onePoint = CGPointMake(-10, -10);
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count == 1) {
        onePoint = CGPointMake(-10, -10);
    }
    NSLog(@"touchesCancelled");
}
- (UIImage *)cropImage
{
    
    extern CGImageRef UIGetScreenImage();//需要先extern
    UIImage *viewImage = [UIImage imageWithCGImage:UIGetScreenImage()];
//    UIImage *viewImage = [UIImage imageWithCGImage:UIGetScreenImage() scale:1.0f orientation:UIImageOrientationRight];
    viewImage = [viewImage subImageInRect:CGRectMake(48, 233, 692, 557)];
//    return viewImage;
    NSLog(@"%lf,%lf",viewImage.size.width,viewImage.size.height);
    NSLog(@"%lf,%lf",viewImage.size.width,viewImage.size.height);
    UIImage *mImage = [UIImage imageWithCGImage:viewImage.CGImage scale:1.0f orientation:UIImageOrientationRight];
    return mImage;

}
@end

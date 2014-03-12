//
//  CropView.h
//  CropDemo
//
//  Created by wangduan on 13-5-30.
//  Copyright (c) 2013年 wxcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarkView;
@interface CropView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat rotation;
    UIImageView        * imageView;
    UIImage            * image;
    MarkView           * markView;
    UIEdgeInsets         imageInset;
    CGSize               cropSize;
    CGSize               normalSize;
    float                normalWidth;
}

@property (strong,nonatomic)UIImageView    * imageView;
@property (strong,nonatomic)UIImage        * image;
@property (strong,nonatomic)MarkView       * markView;
@property (assign,nonatomic)UIEdgeInsets     imageInset;
@property (assign,nonatomic)CGSize           cropSize;
@property (assign,nonatomic)CGSize           normalSize;
- (void)setImage:(UIImage *)image; 
- (void)setCropSize:(CGSize)size;

- (UIImage *)cropImage;
@end

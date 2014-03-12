//
//  MarkView.h
//  CropDemo
//
//  Created by wangduan on 13-5-30.
//  Copyright (c) 2013年 wxcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkView : UIView
{
    CGRect  cropRect;
}
@property (assign,nonatomic)CGRect cropRect;
- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;
@end

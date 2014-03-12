//
//  RootViewController.m
//  CropDemo
//
//  Created by wangduan on 13-5-30.
//  Copyright (c) 2013年 wxcp. All rights reserved.
//

#import "RootViewController.h"
#import "CropView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cropView = [[CropView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    cropView.backgroundColor = [UIColor blackColor];
    [cropView setCropSize:CGSizeMake(557, 692)];
    [cropView setImage:[UIImage imageNamed:@"尊敬.jpeg"]];
    [self.view addSubview:cropView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(900, 400, 80, 31)];
    [btn setTitle:@"剪切" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)crop:sender
{
    UIImage *image = [cropView cropImage];
    [cropView removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat x = (1024 - width) / 2;
    CGFloat y = (748 - height) / 2;
    
    [imageView setFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:imageView];
//    UIImage *image = [cropView cropImage];
//    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil); 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

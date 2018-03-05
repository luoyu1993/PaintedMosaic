//
//  ViewController.m
//  PaintedMosaic
//
//  Created by jesee on 2018/3/5.
//  Copyright © 2018年 cuihanxiu. All rights reserved.
//

#import "ViewController.h"
#import "PKMosaicPaintingController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    [button setTitle:@"开始涂抹" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30.0];
    [button addTarget:self action:@selector(paint) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置图片
    self.image = [UIImage imageNamed:@"gougou"];
    self.imageView.image = self.image;
}

- (void)paint {
    
    PKMosaicPaintingController *shareMosaic = [[PKMosaicPaintingController alloc] initWithImage:self.image];
    [shareMosaic setResultImageBlock:^(UIImage *image){
        if (image) {
            self.image = image;
            self.imageView.image = image;
        }
    }];
    [self presentViewController:shareMosaic animated:YES completion:nil];
    // Dispose of any resources that can be recreated.
}


@end

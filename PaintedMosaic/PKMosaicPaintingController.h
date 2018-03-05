//
//  PKShareController.h
//
//  Created by cuihanxiu on 2017/7/26.
//

#import <UIKit/UIKit.h>

@interface PKMosaicPaintingController : UIViewController
@property (nonatomic, copy) void(^resultImageBlock)(UIImage *image);
- (instancetype)initWithImage:(UIImage *)image;

@end

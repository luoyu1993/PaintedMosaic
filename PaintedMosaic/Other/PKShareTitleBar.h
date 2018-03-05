//
//  PKShareTitleBar.h
//
//  Created by cuihanxiu on 2017/7/26.
//

#import <UIKit/UIKit.h>

@interface PKShareTitleBar : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy) void(^leftActionBlock)(UIButton *button);
@property (nonatomic, copy) void(^rihtActionBlock)(UIButton *button);
@end

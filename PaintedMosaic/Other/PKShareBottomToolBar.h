//
//  PKShareBottomToolBar.h
//
//  Created by cuihanxiu on 2017/7/26.
//

#import <UIKit/UIKit.h>

@interface PKShareBottomToolBar : UIView
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, assign) BOOL brushEnable;
@property (nonatomic, copy) void(^lastOrNextClickBlock)(BOOL isLast);
@property (nonatomic, copy) void(^brushBlock)(NSInteger index);
- (void)setSelectBrushIndex:(NSInteger)index;

@end

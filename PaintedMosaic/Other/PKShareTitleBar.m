//
//  PKShareTitleBar.m
//
//  Created by cuihanxiu on 2017/7/26.
//

#import "PKShareTitleBar.h"
#import "UIColor+Extension.h"

@implementation PKShareTitleBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#00AFF0"];
        [self setupViews];
        [self setupEvents];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}

- (void)setupEvents {
    [self.leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(width * 0.5, 20 + 44 * 0.5);
    [self.leftButton sizeToFit];
    self.leftButton.frame = CGRectMake(15, 0, 40, 40);
    self.leftButton.center = CGPointMake(self.leftButton.center.x, self.titleLabel.center.y);
    [self.rightButton sizeToFit];
    self.rightButton.frame = CGRectMake(width - self.rightButton.bounds.size.width - 14, 0, 40, 40);
    self.rightButton.center = CGPointMake(self.rightButton.center.x, self.titleLabel.center.y);
}

#pragma mark - private method
- (void)leftAction:(UIButton *)button {
    if (self.leftActionBlock) self.leftActionBlock(button);
}

- (void)rightAction:(UIButton *)button {
    if (self.rihtActionBlock) self.rihtActionBlock(button);
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"涂抹";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightButton;
}

@end

//
//  PKShareBottomToolBar.m
//
//  Created by cuihanxiu on 2017/7/26.
//

#import "PKShareBottomToolBar.h"
#import "UIColor+MosaicExtension.h"
#import "PKMosaicButton.h"

static NSInteger const kBrushButtonTag = 100000;

@interface PKShareBottomToolBar ()
@property (nonatomic, strong) UIView *shareToolBackView;
@property (nonatomic, strong) UIView *editToolBackView;
@property (nonatomic, strong) PKMosaicButton *mosaicButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *brushButtons;
@property (nonatomic, assign) BOOL addingMosaic;

@end
@implementation PKShareBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _brushButtons = [NSMutableArray<UIButton *> array];
        self.backgroundColor = [UIColor colorWithHexString:@"#EEEFF3"];
        [self setupViews];
        [self setupEvents];
        [self setAddingMosaic:YES];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.editToolBackView];
    [self.shareToolBackView addSubview:self.mosaicButton];
    [self.editToolBackView addSubview:self.lastButton];
    [self.editToolBackView addSubview:self.nextButton];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.editToolBackView.frame = CGRectMake(0, 0, width, height);
    self.nextButton.frame = CGRectMake(width - 46, 0, 30, 30);
    self.lastButton.frame = CGRectMake(width - 30 - 16 - 16 - 30, 0, 30, 30);
    
    // add mosaic brush
    [self addBrushItems];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nextButton.center = CGPointMake(self.nextButton.center.x, self.bounds.size.height * 0.5);
    self.lastButton.center = CGPointMake(self.lastButton.center.x, self.bounds.size.height * 0.5);
}

- (void)setupEvents {
    [self.lastButton addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addBrushItems {
    CGFloat w = 30;
    CGFloat h = 30;
    CGFloat x = 40;
    CGFloat margin = 15;
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *brushButon = [self setupBrushButton];
        NSString *normalBrushImageName = [NSString stringWithFormat:@"share_mosaic_brush%zd_normal", i + 1];
        NSString *selectedBrushImageName = [NSString stringWithFormat:@"share_mosaic_brush%zd_selected", i + 1];
        [brushButon setImage:[UIImage imageNamed:normalBrushImageName] forState:UIControlStateNormal];
        [brushButon setImage:[UIImage imageNamed:selectedBrushImageName] forState:UIControlStateSelected];
        brushButon.tag = i + kBrushButtonTag;
        brushButon.frame = CGRectMake(x + (w + margin) * i, 0, w, h);
        brushButon.center = CGPointMake(brushButon.center.x, 32);
        brushButon.hidden = YES;
        [self.editToolBackView addSubview:brushButon];
        [self.brushButtons addObject:brushButon];
    }
}

- (UIButton *)setupBrushButton {
    UIButton *brushButton = [[UIButton alloc] init];
    brushButton.layer.masksToBounds = YES;
    [brushButton addTarget:self action:@selector(brushButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return brushButton;
}

- (void)setAddingMosaic:(BOOL)addingMosaic {
    if (_addingMosaic != addingMosaic) {
        _addingMosaic = addingMosaic;
        if (_addingMosaic) {
            [self hideBackView:self.editToolBackView hidden:NO];
            [self hideBackView:self.shareToolBackView hidden:YES];
        } else {
            [self hideBackView:self.editToolBackView hidden:YES];
            [self hideBackView:self.shareToolBackView hidden:NO];
        }
    }
}

- (void)hideBackView:(UIView *)backView hidden:(BOOL)hide {
    [backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = hide;
    }];
    backView.hidden = hide;
}

- (void)setBrushEnable:(BOOL)brushEnable {
    if (_brushEnable != brushEnable) {
        _brushEnable = brushEnable;
        [self.brushButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) obj.userInteractionEnabled = brushEnable;
        }];
        self.lastButton.userInteractionEnabled = brushEnable;
        self.nextButton.userInteractionEnabled = brushEnable;
    }
}

- (void)setSelectBrushIndex:(NSInteger)index {
    for (UIButton *button in self.brushButtons) {
        if (button.tag - kBrushButtonTag == index) {
            [self brushButtonClicked:button];
        }
    }
}

#pragma mark - events
- (void)brushButtonClicked:(UIButton *)button {
    [self.brushButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    button.selected = YES;
    if (self.brushBlock) self.brushBlock(button.tag - kBrushButtonTag);
}

- (void)operationAction:(UIButton *)button {
    if (self.lastOrNextClickBlock) self.lastOrNextClickBlock((button == self.lastButton));
}

#pragma mark - getter
- (UIView *)shareToolBackView {
    if (!_shareToolBackView) {
        _shareToolBackView = [[UIView alloc] init];
    }
    return _shareToolBackView;
}

- (UIView *)editToolBackView {
    if (!_editToolBackView) {
        _editToolBackView = [[UIView alloc] init];
        _editToolBackView.backgroundColor = [UIColor colorWithHexString:@"#EEEFF3"];
        _editToolBackView.hidden = YES;
    }
    return _editToolBackView;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [[UIButton alloc] init];
        [_lastButton setImage:[UIImage imageNamed:@"share_mosaic_last_normal"] forState:UIControlStateNormal];
        [_lastButton setImage:[UIImage imageNamed:@"share_mosaic_last_pressed"] forState:UIControlStateDisabled];
    }
    return _lastButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton setImage:[UIImage imageNamed:@"share_mosaic_next_normal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"share_mosaic_next_pressed"] forState:UIControlStateDisabled];
    }
    return _nextButton;
}
@end

//
//  PKShareController.m
//
//  Created by cuihanxiu on 2017/7/26.
//

#import "PKMosaicPaintingController.h"
#import "PKShareTitleBar.h"
#import "PKMosaicDrawingboard.h"
#import "PKShareBottomToolBar.h"
#import "UIImage+Mosaic.h"

@interface PKMosaicPaintingController ()
@property (nonatomic, strong) PKShareTitleBar *titleBar;
@property (nonatomic, strong) PKShareBottomToolBar *bottomToolBar;
// 油画马赛克涂抹板
@property (nonatomic, strong) PKMosaicDrawingboard *mosaicDrawingboard;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PKMosaicPaintingController
#pragma mark - life cycle
- (void)dealloc {
    [self.mosaicDrawingboard removeObserver:self forKeyPath:@"lastAble"];
    [self.mosaicDrawingboard removeObserver:self forKeyPath:@"nextAble"];
    [self.mosaicDrawingboard removeObserver:self forKeyPath:@"touching"];
    [self.mosaicDrawingboard removeObserver:self forKeyPath:@"painting"];
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [self init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self setupEvents];
    [self bindData];
    
    // 默认开始编辑
    [self.mosaicDrawingboard beginPaint];
    // 默认开始选中第三个笔触
    [self.bottomToolBar setSelectBrushIndex:1];
}

#pragma mark - private method
- (void)setupViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mosaicDrawingboard];
    [self.view addSubview:self.titleBar];
    [self.view addSubview:self.bottomToolBar];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    // layout constrains
    self.titleBar.frame = CGRectMake(0, 0, width, 64);
    self.bottomToolBar.frame = CGRectMake(0, height - 64, width, 64);
    self.bottomToolBar.frame = CGRectMake(0, height - 64, width, 64);
    self.bottomToolBar.backgroundColor = [UIColor orangeColor];

}

- (void)setupEvents {
    UIImage *(^resizeImageBlock)(NSInteger) = ^UIImage *(NSInteger index){
        NSString *name = @"";
        // 图片1倍大小是50x50
        // 从小到大0.5, 0.75, 1.0, 1.25倍. 注意图片像素不要出现.5
        switch (index) {
            case 0:
                name = @"mosaic_asset_12_0.5";
                break;
            case 1:
                name = @"mosaic_asset_12_0.75";
                break;
            case 2:
                name = @"mosaic_asset_12";
                break;
            case 3:
                name = @"mosaic_asset_12_1.25";
                break;
            default:
                break;
        }
        UIImage *image =  [UIImage imageNamed:name];
        NSCAssert(image, @"没有该图片资源");
        return image;
    };
    __weak typeof(self) wself = self;
    // titleBar
    [self.titleBar setLeftActionBlock:^(UIButton *button){
        [wself.mosaicDrawingboard cancelPaint];
        [wself popback];
    }];
    
    [self.titleBar setRihtActionBlock:^(UIButton *button){
        UIImage *image = [wself.mosaicDrawingboard compeletePaint];
        if (wself.resultImageBlock) wself.resultImageBlock(image);
        [wself popback];
    }];
    
    [self.bottomToolBar setBrushBlock:^(NSInteger index){
        switch (index) {
            case 0: {
                [wself.mosaicDrawingboard setMosaicBrushImage:resizeImageBlock(0)];
            }
                break;
            case 1: {
                [wself.mosaicDrawingboard setMosaicBrushImage:resizeImageBlock(1)];
            }
                break;
            case 2: {
                [wself.mosaicDrawingboard setMosaicBrushImage:resizeImageBlock(2)];
            }
                break;
            case 3: {
                [wself.mosaicDrawingboard setMosaicBrushImage:resizeImageBlock(3)];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self.bottomToolBar setLastOrNextClickBlock:^(BOOL isLast){
        if (isLast) {
            [wself.mosaicDrawingboard last];
        } else {
            [wself.mosaicDrawingboard next];
        }
    }];
}

- (void)popback {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bindData {
    self.titleBar.titleLabel.text = @"单指涂抹, 双指滑动";
    self.mosaicDrawingboard.image = self.image;
    
    [self.mosaicDrawingboard addObserver:self forKeyPath:@"lastAble" options:NSKeyValueObservingOptionInitial context:NULL];
    [self.mosaicDrawingboard addObserver:self forKeyPath:@"nextAble" options:NSKeyValueObservingOptionInitial context:NULL];
    [self.mosaicDrawingboard addObserver:self forKeyPath:@"touching" options:NSKeyValueObservingOptionInitial context:NULL];
    [self.mosaicDrawingboard addObserver:self forKeyPath:@"painting" options:NSKeyValueObservingOptionInitial context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"lastAble"]) {
        self.bottomToolBar.lastButton.enabled = self.mosaicDrawingboard.lastAble;
    } else if ([keyPath isEqualToString:@"nextAble"]){
        self.bottomToolBar.nextButton.enabled = self.mosaicDrawingboard.nextAble;
    } else if ([keyPath isEqualToString:@"touching"]){
        self.bottomToolBar.brushEnable = !self.mosaicDrawingboard.touching;
    } else if ([keyPath isEqualToString:@"painting"]){
        self.titleBar.rightButton.hidden = !self.mosaicDrawingboard.painting;
    }
}

#pragma mark - getter
- (PKShareTitleBar *)titleBar {
    if (!_titleBar) {
        _titleBar = [[PKShareTitleBar alloc] init];
    }
    return _titleBar;
}

- (PKShareBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[PKShareBottomToolBar alloc] init];
    }
    return _bottomToolBar;
}

- (PKMosaicDrawingboard *)mosaicDrawingboard {
    if (!_mosaicDrawingboard) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _mosaicDrawingboard = [[PKMosaicDrawingboard alloc] initWithFrame:CGRectMake(0, 64, width, height - 64 - 64)];
    }
    return _mosaicDrawingboard;
}

@end

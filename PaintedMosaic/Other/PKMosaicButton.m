//
//  PKMosaicButton.m
//
//  Created by cuihanxiu on 2017/4/28.
//

#import "PKMosaicButton.h"

@implementation PKMosaicButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [self sizeReset];
}

- (void)sizeReset {
    if (self.titleLabel.text.length && self.imageView.image) {
        CGSize l_size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
        CGSize i_size = self.imageView.image.size;
        self.bounds = CGRectMake(0, 0, l_size.width + 10, i_size.height + l_size .height+ 4);
        self.titleLabel.frame = CGRectMake(0, i_size.height + 4, l_size.width, l_size.height);
        self.titleLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.titleLabel.center.y);
        self.imageView.frame = CGRectMake(0, 0, i_size.width, i_size.height);
        self.imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.imageView.center.y);
    }
}

@end

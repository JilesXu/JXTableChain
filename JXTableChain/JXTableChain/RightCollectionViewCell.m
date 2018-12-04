//
//  RightCollectionViewCell.m
//  JXTableChain
//
//  Created by 徐沈俊杰 on 2018/12/4.
//  Copyright © 2018 JX. All rights reserved.
//

#import "RightCollectionViewCell.h"
#import "Masonry.h"

#define kSCALE ([UIScreen mainScreen].bounds.size.width/375)
#define kTO_SCALE(x) (kSCALE*x)

@interface RightCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *intervalLine;
@property (nonatomic, strong) UILabel *gridLabel;

@end

@implementation RightCollectionViewCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - Events Response

#pragma mark - Method
- (void)refreshRightCollectionViewCell:(NSInteger)indexPath {
    self.gridLabel.text = [NSString stringWithFormat:@"%ld", indexPath];
}

- (void)addSubviews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.intervalLine];
    [self.containerView addSubview:self.gridLabel];
}

- (void)setupFrame {
    [self layoutIfNeeded];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.intervalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.left.equalTo(self.containerView.mas_left).offset(kTO_SCALE(15));
        make.right.equalTo(self.containerView.mas_right).offset(kTO_SCALE(-15));
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}

#pragma mark - Setting And Getting
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _containerView;
}

- (UIView *)intervalLine {
    if (!_intervalLine) {
        _intervalLine = [[UIView alloc] init];
        _intervalLine.backgroundColor = [UIColor blackColor];
    }
    
    return _intervalLine;
}

- (UILabel *)gridLabel {
    if (!_gridLabel) {
        _gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _gridLabel.textAlignment = NSTextAlignmentCenter;
        _gridLabel.font = [UIFont systemFontOfSize:15];
        _gridLabel.textColor = [UIColor blackColor];
    }
    
    return _gridLabel;
}
@end

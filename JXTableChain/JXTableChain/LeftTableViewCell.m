//
//  LeftTableViewCell.m
//  JXTableChain
//
//  Created by 徐沈俊杰 on 2018/12/4.
//  Copyright © 2018 JX. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - Events Response

#pragma mark - Method
- (void)addSubviews {
    
}

- (void)setupFrame {
    
}

#pragma mark - Setting And Getting
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor orangeColor];
}

@end

//
//  JXTableChainView.m
//  JXTableChain
//
//  Created by 徐沈俊杰 on 2018/12/4.
//  Copyright © 2018 JX. All rights reserved.
//

#import "JXTableChainView.h"
#import "LeftTableViewCell.h"
#import "RightCollectionViewCell.h"
#import "Masonry.h"

#define kSCALE ([UIScreen mainScreen].bounds.size.width/375)
#define kTO_SCALE(x) (kSCALE*x)

#define kLeftTableViewCell @"kLeftTableViewCell"
#define kRightCollectionViewCell @"kRightCollectionViewCell"

#define kLeftWdth

@interface JXTableChainView() <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;

@property (nonatomic, strong) NSIndexPath *lastPath;
@property (nonatomic, assign) BOOL isRepeatRolling;

/**
 左侧tableview宽度占比
 */
@property (nonatomic, assign) CGFloat leftProportion;

@end

@implementation JXTableChainView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame andLeftWidthProportion:(CGFloat)leftProportion {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.isRepeatRolling = NO;
        self.lastPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if (leftProportion < 1) {
            self.leftProportion = leftProportion;
        } else {
            self.leftProportion = 0.2;
        }
        
        [self addSubviews];
        [self setupFrame];
    }
    
    return self;
}

#pragma mark - TabelView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
    if (!cell) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLeftTableViewCell];
    }
    
    NSInteger row = [indexPath row];
    NSInteger lastRow = [self.lastPath row];
    if (row==lastRow && self.lastPath!=nil) {
        // 被选中状态
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return kTO_SCALE(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeftTableViewCell *cell = [self.leftTableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    NSInteger currentRow = [indexPath row];
    NSInteger lastRow = (self.lastPath != nil) ? [self.lastPath row] : -1;
    if (currentRow != lastRow) {
        LeftTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.contentView.backgroundColor = [UIColor whiteColor];

        LeftTableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastPath];
        lastCell.contentView.backgroundColor = [UIColor orangeColor];
    }

    self.lastPath = indexPath;
    self.isRepeatRolling = YES;
    
    NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self.rightCollectionView scrollToItemAtIndexPath:moveToIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
}

#pragma mark - Collection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RightCollectionViewCell *cell = [self.rightCollectionView dequeueReusableCellWithReuseIdentifier:kRightCollectionViewCell forIndexPath:indexPath];
    
    [cell refreshRightCollectionViewCell:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == self.rightCollectionView) {
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        if (bottomOffset <= height) {
            NSIndexPath *bottomIndexPath = [[self.rightCollectionView indexPathsForVisibleItems] lastObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:bottomIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) { // 防止重复滚动
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
            
        } else {
            NSIndexPath *topIndexPath = [[self.rightCollectionView indexPathsForVisibleItems] firstObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) { // 防止重复滚动
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
        
    } else {
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isRepeatRolling = NO;
}

#pragma mark - Events Response

#pragma mark - Method
- (void)addSubviews {
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightCollectionView];
}

- (void)setupFrame {
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CGRectGetWidth(self.frame) * self.leftProportion);
        make.height.equalTo(self.mas_height);
        make.top.left.equalTo(self);
    }];
    
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.top.bottom.equalTo(self.leftTableView);
        make.right.equalTo(self.mas_right);
    }];
}

#pragma mark - Setting And Getting
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewScrollPositionNone;
        _leftTableView.backgroundColor = [UIColor redColor];
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        _leftTableView.contentInset = UIEdgeInsetsZero;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.clipsToBounds = YES;
        _leftTableView.estimatedRowHeight = 0;
        _leftTableView.estimatedSectionHeaderHeight = 0;
        _leftTableView.estimatedSectionFooterHeight = 0;
        
    }
    
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame) * (1 - self.leftProportion), kTO_SCALE(110));
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.pagingEnabled = NO;
        _rightCollectionView.backgroundColor = [UIColor blueColor];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.backgroundColor = [UIColor greenColor];
        [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:kRightCollectionViewCell];
    }
    
    return _rightCollectionView;
}
@end

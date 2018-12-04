//
//  ViewController.m
//  JXTableChain
//
//  Created by 徐沈俊杰 on 2018/9/18.
//  Copyright © 2018年 JX. All rights reserved.
//

#import "ViewController.h"
#import "JXTableChainView.h"

@interface ViewController ()

@property (nonatomic, strong) JXTableChainView *tableChainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableChainView];
}


- (JXTableChainView *)tableChainView {
    
    if (!_tableChainView) {
        _tableChainView = [[JXTableChainView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) andLeftWidthProportion:0.3];
    }
    
    return _tableChainView;
}

@end

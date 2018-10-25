//
//  HomeViewController.m
//  PageControlDemo
//
//  Created by ios2 on 2018/10/25.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import "HomeViewController.h"
#import "LgPageControlViewController.h"

@interface HomeViewController ()<LgPageControlDelegate>

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {

    [super viewDidLoad];
	[self.navigationController.navigationBar setTranslucent:NO];
	CGFloat topY =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
	
	LgPageView *pageView =[[LgPageView alloc]initWithFrame:CGRectMake(0, topY, CGRectGetWidth(self.view.frame)- 30.0f, 40.0f)];
	[self.view addSubview:pageView];
	
	LgPageControlViewController *pageVc = [[LgPageControlViewController alloc]initWithTitleView:pageView andDelegateVc:self];
	
	pageVc.view.frame = CGRectMake(0,
								   CGRectGetMaxY(pageView.frame),
								   CGRectGetWidth(self.view.frame),
								   CGRectGetHeight(self.view.frame) - CGRectGetHeight(pageView.frame));
}
#pragma mark LgPageControlDelegate

-(NSInteger)lgPageControl:(LgPageControlViewController *)pageController
{
	return 3;
}
-(UIViewController *)lgPageControl:(LgPageControlViewController *)pageController withIndex:(NSInteger)index
{
	UIViewController *vc = [[UIViewController alloc]init];
	return vc;
}

-(NSArray *)lgPageTitlesWithLgPageView:(LgPageView *)pageView
{
	return @[@"张三李四王",@"李四房间爱开始放假奥斯卡",@"王五飞机撒开房间爱卡"];
}

@end

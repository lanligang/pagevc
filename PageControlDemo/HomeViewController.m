//
//  HomeViewController.m
//  PageControlDemo
//
//  Created by ios2 on 2018/10/25.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import "HomeViewController.h"
#import "ASubVcViewController.h"
#import "BSubVcViewController.h"

#import "LgPageControlViewController.h"
@interface HomeViewController ()<LgPageControlDelegate>{
	LgPageControlViewController *_pageVc;
}

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {

    [super viewDidLoad];
	[self.dataSource addObjectsFromArray:@[@"张三李四王"]];
	[self.navigationController.navigationBar setTranslucent:NO];

	CGFloat topY =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);

	LgPageView *pageView =[[LgPageView alloc]initWithFrame:CGRectMake(0, topY, CGRectGetWidth(self.view.frame) - 30, 40.0f)
											  andTitleFont:[UIFont systemFontOfSize:18.0f]
										   andSeletedColor:[UIColor redColor]
											andNormalColor:nil
											  andLineColor:nil
											 andLineHeight:3.0f];

	[self.view addSubview:pageView];
	
	LgPageControlViewController *pageVc = [[LgPageControlViewController alloc]initWithTitleView:pageView andDelegateVc:self];
	_pageVc = pageVc;
	pageVc.view.frame = CGRectMake(0,
								   CGRectGetMaxY(pageView.frame),
								   CGRectGetWidth(self.view.frame),
								   CGRectGetHeight(self.view.frame) - CGRectGetHeight(pageView.frame));


	UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[changeBtn setTitle:@"换" forState:UIControlStateNormal];
	[changeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	changeBtn.bounds = CGRectMake(0, 0, 30, 30);
	changeBtn.center = (CGPoint){CGRectGetMaxX(pageView.frame) + 15.0f, pageView.center.y};
	[changeBtn addTarget:self action:@selector(changeCountClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:changeBtn];
}

#pragma mark  按钮点击
-(void)changeCountClicked:(UIButton *)btn
{
	[self.dataSource addObjectsFromArray:@[@"张三李",@"王五"]];
	[_pageVc reloadData];
}

#pragma mark LgPageControlDelegate

-(NSInteger)lgPageControl:(LgPageControlViewController *)pageController
{
	return self.dataSource.count;
}
-(UIViewController *)lgPageControl:(LgPageControlViewController *)pageController withIndex:(NSInteger)index
{
	NSString *aclassNames[2] = {@"ASubVcViewController",@"BSubVcViewController"};
	NSInteger vcIndex = index%2;
	NSString *className = aclassNames[vcIndex];
	UIViewController *vc = [[NSClassFromString(className) alloc]init];
	return vc;
}

-(NSArray *)lgPageTitlesWithLgPageView:(LgPageView *)pageView
{
	return self.dataSource;
}

-(NSMutableArray *)dataSource
{
	if (!_dataSource)
	 {
		_dataSource = [[NSMutableArray alloc]init];
	 }
	return _dataSource;
}







@end

//
//  LgPageControlViewController.m
//  PageControlDemo
//
//  Created by ios2 on 2018/10/25.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import "LgPageControlViewController.h"

#define MINX_VIEW_TAG 3000

@interface LgPageControlViewController ()<UIScrollViewDelegate>
{
	//滚动到的当前页面
	NSInteger _currentPage;
	LgPageView *_pageTitleView;
}
@property (nonatomic,strong)UIScrollView *bgScrollView;

@end

@implementation LgPageControlViewController
-(instancetype)initWithTitleView:(LgPageView *)titleView
				   andDelegateVc:(UIViewController<LgPageControlDelegate> *)delegateVc
{
	self =[super init];
	if (self) {
		self.lgDelegate = delegateVc;
		_pageTitleView = titleView;
		_pageTitleView.pageVc = self;
		_pageTitleView.delegate = delegateVc;
		//创建UI
		[_pageTitleView configeUI];
		[delegateVc addChildViewController:self];
		[delegateVc.view addSubview:self.view];
	}
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.bgScrollView];
	if (self.lgDelegate) {
		_currentPage = 0;
		[self loadChildVcWithIndex:0];
	}
}
#pragma mark 去加载控制器
-(void)loadChildVcWithIndex:(NSInteger)page
{
	//加载子控制器
	NSAssert(self.lgDelegate != nil, @"设置 LgPageControlViewController 代理");
	if (self.lgDelegate) {
		if ([self.lgDelegate respondsToSelector:@selector(lgPageControl:withIndex:)]) {
			NSInteger pageCount = [self.lgDelegate lgPageControl:self];
			NSInteger maxPage = pageCount - 1;
			if (page > maxPage||pageCount <= 0 )return;
		    UIViewController *vc = 	[self.lgDelegate lgPageControl:self withIndex:page];
			NSAssert([vc isKindOfClass:[UIViewController class]], @"请检查 lgPageControl:withIndex:代理方法返回类型");
			[self addChildViewController:vc];
			vc.view.tag = MINX_VIEW_TAG + page;

			NSArray *colors = @[
								[UIColor redColor],
								[UIColor greenColor],
								[UIColor yellowColor],
								[UIColor purpleColor],
								[UIColor orangeColor]];
			vc.view.backgroundColor = colors[page%5];

			vc.view.frame = CGRectMake(page*CGRectGetWidth(self.bgScrollView.frame),
									   0,
									   CGRectGetWidth(self.bgScrollView.frame),
									   CGRectGetHeight(self.bgScrollView.frame));
			[self.bgScrollView addSubview:vc.view];
		}
	}
}
#pragma mark layout subViews
-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
   CGFloat width = 	CGRectGetWidth(self.view.frame);
   CGFloat height = 	CGRectGetHeight(self.view.frame);
	_bgScrollView.frame = CGRectMake(0, 0, width, height);
	//通过代理向外部要数据
	if (self.lgDelegate) {
		if ([self.lgDelegate respondsToSelector:@selector(lgPageControl:)]) {
			NSInteger pageCount = [self.lgDelegate lgPageControl:self];
			_bgScrollView.contentSize = CGSizeMake(pageCount*width, 0);
		}
	}
	NSArray *containtViews = 	_bgScrollView.subviews;
	if (containtViews.count>0) {
		for (int i = 0; i< containtViews.count; i++) {
			//这里修改View 的frame
			UIView *v = containtViews[i];
			NSInteger vTag = (v.tag - MINX_VIEW_TAG);
			v.frame = CGRectMake(vTag*width, 0, width, height);
		}
	}
	[self scrollTopage:_currentPage];
}

#pragma mark 移除所有的自视图
-(void)removeChildViewControllersAndView
{
	[self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj willMoveToParentViewController:nil];
		[obj.view removeFromSuperview];
		[obj removeFromParentViewController];
	}];
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat offSetX = scrollView.contentOffset.x;
	if ([self.lgDelegate respondsToSelector:@selector(lgPageControl:didScrollOffSet:)]) {
		[self.lgDelegate lgPageControl:self didScrollOffSet:offSetX];
	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat offSetX = scrollView.contentOffset.x;
	NSInteger page = offSetX/(CGRectGetWidth(scrollView.frame) - 0.1)/1;
	_currentPage  = page;
	[_pageTitleView didScrollToPage:page];
	if (self.lgDelegate) {
	     UIView *subView = (UIView *)[scrollView viewWithTag:MINX_VIEW_TAG+page];
		if (!subView) {
			[self loadChildVcWithIndex:page];
		}
	}
}

/**
 * 刷新界面使用
 */
-(void)reloadData
{
	[self removeChildViewControllersAndView];

	CGFloat width = 	CGRectGetWidth(self.view.frame);
	CGFloat height = 	CGRectGetHeight(self.view.frame);
	_bgScrollView.frame = CGRectMake(0, 0, width, height);
		//通过代理向外部要数据
	if (self.lgDelegate) {
		if ([self.lgDelegate respondsToSelector:@selector(lgPageControl:)]) {

			NSInteger pageCount = [self.lgDelegate lgPageControl:self];

			_bgScrollView.contentSize = CGSizeMake(pageCount*width, 0);
		}
	}
	[self scrollTopage:0];
}
//滚动到某一页
-(void)scrollTopage:(NSInteger)page
{
	_currentPage = page;
	CGFloat offSetX = CGRectGetWidth(self.view.frame) * _currentPage;
	[self.bgScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
	
}

-(void)endScroll:(NSInteger)page
{
	_currentPage = page;
	CGFloat offSetX = CGRectGetWidth(self.view.frame) * _currentPage;
	[self.bgScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
	
	if (self.lgDelegate) {
		UIView *subView = (UIView *)[self.bgScrollView viewWithTag:MINX_VIEW_TAG+page];
		if (!subView) {
			[self loadChildVcWithIndex:page];
		}
	}
}

-(NSInteger)lgCurrentPage
{
	return _currentPage;
}

#pragma mark Getter
-(UIScrollView *)bgScrollView
{
	if (!_bgScrollView) {
		_bgScrollView = [[UIScrollView alloc]init];
		[_bgScrollView setBounces:NO];
		[_bgScrollView setPagingEnabled:YES];
		[_bgScrollView setShowsVerticalScrollIndicator:NO];
		[_bgScrollView setShowsHorizontalScrollIndicator:NO];
		_bgScrollView.delegate = self;
	 }
	return _bgScrollView;
}


@end

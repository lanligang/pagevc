//
//  LgPageView.m
//  PageControlDemo
//
//  Created by ios2 on 2018/10/25.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import "LgPageView.h"
#import "LgPageControlViewController.h"


#define MIN_ITEM_TAG 555

#define LEFT_RIGHT_SPACE 10.0f

@interface LgPageView ()
{
	UIView *_lineView;
	UIColor *_seletedColor;
	UIColor *_normalColor;
	UIFont  * _titleFont;
	CGFloat _lineHeight;
	UIColor *_lineColor;
}
//标签集合
@property (nonatomic,strong)NSMutableArray *Items;

@property (nonatomic,strong)UIScrollView *bgScrollView;

@end

@implementation LgPageView


-(instancetype)initWithFrame:(CGRect)frame
				andTitleFont:(UIFont *)titleFont
			 andSeletedColor:(UIColor *)seletedColor
			  andNormalColor:(UIColor *)normalColor
				andLineColor:(UIColor *)lineColor
			   andLineHeight:(CGFloat)lineHeight
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		[self addSubview:self.bgScrollView];
		_lineHeight = 2.0f;
		_seletedColor = seletedColor;
		_normalColor = normalColor;
		_titleFont = titleFont;
		_lineColor = lineColor;
		//三者都不存在
		if (!_seletedColor) {
			_seletedColor  = [UIColor redColor];
		}
		if (!_normalColor) {
			_normalColor = [UIColor blackColor];
		}
		if (!_titleFont) {
			_titleFont = [UIFont systemFontOfSize:16.0f];
		}
		if (lineHeight != 0) {
			_lineHeight = lineHeight;
		}
		if (!_lineColor) {
			_lineColor = [UIColor redColor];
		}
	}
	return self;
}

-(void)configeUI
{
	// 初始化构建UI
	[self.Items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UIView *titleView = obj;
		[titleView removeFromSuperview];
	}];
	if (_lineView) {
		[_lineView removeFromSuperview];
		_lineView = nil;
	}
	NSAssert(self.delegate != nil, @"设置 LgPageControlViewController 代理");
	NSAssert([self.delegate respondsToSelector:@selector(lgPageTitlesWithLgPageView:)], @"未能实现必要的方法 lgPageTitlesWithLgPageView");
	NSArray *titles = [self.delegate lgPageTitlesWithLgPageView:self];
	if (titles) {
		NSInteger titleCount = titles.count;
		CGFloat maxX = 0;
		CGFloat space = 10;
		CGFloat top = 0;
		CGFloat lineHeight = _lineHeight;
		CGFloat height = CGRectGetHeight(self.frame) - top - lineHeight;
		for (int i = 0; i < titleCount; i++) {
			UILabel *titleLable = [UILabel new];
			titleLable.text = titles[i];
			titleLable.textColor = _normalColor;
			titleLable.tag = MIN_ITEM_TAG + i;
			titleLable.font  = _titleFont;
			[self.Items addObject:titleLable];

		    CGFloat itemWidth = 	[titleLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 10)].width;
			if (i == 0) {
				titleLable.frame = CGRectMake(maxX+LEFT_RIGHT_SPACE, top, itemWidth, height);
			}else{
				titleLable.frame = CGRectMake(maxX+space, top, itemWidth, height);
			}
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ontapAction:)];
			[titleLable addGestureRecognizer:tap];
			titleLable.userInteractionEnabled = YES;
			maxX  = CGRectGetMaxX(titleLable.frame);
			[self.bgScrollView addSubview:titleLable];
			if (i == 0) {
				UIView *lineView =[UIView new];
				_lineView = lineView;
				titleLable.textColor = _seletedColor;
				_lineView.backgroundColor = _lineColor;
				[self.bgScrollView addSubview:lineView];
				_lineView.bounds = CGRectMake(0, 0, itemWidth, lineHeight);
				_lineView.center = CGPointMake(titleLable.center.x, CGRectGetMaxY(titleLable.frame) - lineHeight);
			}
		}
		CGFloat widthSelf = CGRectGetWidth(self.frame);
		maxX = maxX +LEFT_RIGHT_SPACE;
		if (maxX<widthSelf) {
			maxX = widthSelf;
		}
		//滚动视图的上顶高度
		CGFloat heightScroll = height + top;

		self.bgScrollView.frame = CGRectMake(0, 0, widthSelf, heightScroll);

		self.bgScrollView.contentSize = (CGSize){maxX,0};
		[self.bgScrollView bringSubviewToFront:_lineView];
	}
}
-(void)ontapAction:(UITapGestureRecognizer *)tap
{
	NSInteger page = tap.view.tag - MIN_ITEM_TAG;
	if (self.pageVc) {
		[self.pageVc endScroll:page];
	}
	[self didScrollToPage:page];
	
}

-(void)didScrollToPage:(NSInteger)page
{
	NSInteger pageTag = MIN_ITEM_TAG + page;
	UILabel *currentTitle = (UILabel *)[self.bgScrollView viewWithTag:pageTag];
	CGFloat width = CGRectGetWidth(currentTitle.frame);
	CGRect rect = CGRectMake(0, 0, width, CGRectGetHeight(_lineView.frame));
	CGPoint center = (CGPoint){currentTitle.center.x,_lineView.center.y};

	[self.Items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		UILabel *lable = obj;
		if (lable == currentTitle) {
			lable.textColor =self-> _seletedColor;
		}else{
			lable.textColor =self-> _normalColor;
		}
	}];
	[UIView animateWithDuration:0.15 animations:^{
		self->_lineView.bounds = rect;
		self->_lineView.center = center;
	}];
	//查看一下位置
	CGRect aRect  = [self.bgScrollView convertRect:currentTitle.bounds fromView:currentTitle];
	
	CGFloat minX = CGRectGetMinX(aRect);
	CGFloat maxX = CGRectGetMaxX(aRect);

	if (maxX >= CGRectGetWidth(self.frame)) {
		//超过最右边了
		CGFloat aCenterX =  aRect.origin.x -self.bgScrollView.contentOffset.x +aRect.size.width/2.0f;
		CGFloat shouldChangeX = self.bgScrollView.contentOffset.x + (aCenterX - CGRectGetWidth(self.bgScrollView.frame)/2.0f);
		BOOL isOffSet =  (self.bgScrollView.contentSize.width - shouldChangeX - CGRectGetWidth(self.bgScrollView.frame) ) >= 0?YES:NO;
		
		if (isOffSet) {
			
			[self.bgScrollView setContentOffset:CGPointMake(shouldChangeX, 0) animated:YES];
			
		}else{
				CGFloat aChangeX =  self.bgScrollView.contentSize.width - CGRectGetWidth(self.bgScrollView.frame);
				[self.bgScrollView setContentOffset:CGPointMake(aChangeX, 0) animated:YES];
		}
		
	}else if (minX <= CGRectGetWidth(self.frame)){
		
		CGFloat aCenterX = self.bgScrollView.contentOffset.x - aRect.origin.x +aRect.size.width/2.0f;
		CGFloat shouldChangeX = self.bgScrollView.contentOffset.x  - aCenterX;
		//是否需要偏移
		BOOL isOffSet = minX - self.bgScrollView.contentOffset.x - 10 <= 0 ?YES:NO;
		if (shouldChangeX <= 0) {
			shouldChangeX = 0;
		}
		if (isOffSet) {
			//需要偏移的时候
			[self.bgScrollView setContentOffset:CGPointMake(shouldChangeX, 0) animated:YES];
		}
		
	}
}

#pragma mark Getter
-(NSMutableArray *)Items
{
	if (!_Items)
	 {
		_Items = [[NSMutableArray alloc]init];
	 }
	return _Items;
}
-(UIScrollView *)bgScrollView
{
	if (!_bgScrollView)
	 {
		_bgScrollView = [[UIScrollView alloc]init];
		[_bgScrollView setShowsVerticalScrollIndicator:NO];
		[_bgScrollView setShowsHorizontalScrollIndicator:NO];
	 }
	return _bgScrollView;
}

@end

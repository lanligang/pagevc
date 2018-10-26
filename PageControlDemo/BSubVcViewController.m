//
//  BSubVcViewController.m
//  PageControlDemo
//
//  Created by ios2 on 2018/10/26.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import "BSubVcViewController.h"

@interface BSubVcViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@end

@implementation BSubVcViewController

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSLog(@"调用将要出现代码了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:self.myTableView];
	[_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	_myTableView.delegate = self;
	_myTableView.dataSource = self;
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	self.myTableView.frame = self.view.bounds;
}

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	cell =  [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = @"我是子控制器B";
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return nil;
}


#pragma mark Getter
-(UITableView *)myTableView
{
	if (!_myTableView)
	 {
		_myTableView = [[UITableView alloc]init];
	 }
	return _myTableView;
}


@end

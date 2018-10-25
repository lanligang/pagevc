//
//  LgPageView.h
//  PageControlDemo
//
//  Created by ios2 on 2018/10/25.
//  Copyright © 2018 山舟网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LgPageControlDelegate.h"

@class LgPageControlViewController;

@interface LgPageView : UIView

@property(nonatomic,weak)id <LgPageControlDelegate> delegate;

//设置的pageVc
@property(nonatomic,weak)LgPageControlViewController * pageVc;

-(void)configeUI;

//下面的分页滚动到第几页了
-(void)didScrollToPage:(NSInteger)page;



@end

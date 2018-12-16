
![龙猫图片](https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike150%2C5%2C5%2C150%2C50/sign=748f02e80cf431ada8df4b6b2a5fc7ca/f11f3a292df5e0fe5f1d6e7b5c6034a85edf7247.jpg)
###
```
/**
*  andTitleFont    文字字体
*  andSeletedColor 选中颜色
*  andNormalColor  正常颜色
*  andLineColor    底部颜色
*  andLineHeight   线条高度
*/
LgPageView *pageView =[[LgPageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 30, 40.0f)
andTitleFont:[UIFont systemFontOfSize:18.0f]
andSeletedColor:[UIColor redColor]
andNormalColor:nil
andLineColor:nil
andLineHeight:3.0f];

[self.view addSubview:pageView];


/**
*  初始化 使用此方法
-(instancetype)initWithTitleView:(LgPageView *)titleView
andDelegateVc:(UIViewController<LgPageControlDelegate> *)delegateVc;

//是否可以清理之前的数据
@property(nonatomic,assign)BOOL canClearSubVcCache;

//最小清理数量
@property(nonatomic,assign)NSInteger minClearCount;

//当前页面
@property(nonatomic,assign,readonly)NSInteger lgCurrentPage;

/**
* 刷新界面使用
*/
-(void)reloadData;

//往后面追加
-(void)addPageNumber;

*/
LgPageControlViewController *pageVc = [[LgPageControlViewController alloc]initWithTitleView:pageView andDelegateVc:self];
pageVc.canClearSubVcCache = YES;
pageVc.minClearCount = 5;
_pageVc = pageVc;
pageVc.view.frame = CGRectMake(0,
CGRectGetMaxY(pageView.frame),
CGRectGetWidth(self.view.frame),
CGRectGetHeight(self.view.frame)- CGRectGetMaxY(pageView.frame));

```
### 代理回调
```
-(NSInteger)lgPageControl:(LgPageControlViewController *)pageController;

-(UIViewController *)lgPageControl:(LgPageControlViewController *)pageController withIndex:(NSInteger)index;

-(NSArray *)lgPageTitlesWithLgPageView:(LgPageView *)pageView;
```
### 内部使用了 NSObject+LgObserver 实现了 KVO

![💪](https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike150%2C5%2C5%2C150%2C50/sign=9d214561d40735fa85fd46ebff3864d6/f703738da97739128522621bf8198618367ae240.jpg)

[大龙猫哈哈](https://baike.baidu.com/item/龙猫/12015836)

//
//  CCTabBarController.m
//  CCTabControllerTools
//
//  Created by Wang youdong on 2019/9/30.
//  Copyright © 2019 Jack. All rights reserved.
//

#import "CCTabBarController.h"
#import "CCTabBar.h"
#import "Wallpaper-Swift.h"
@interface CCTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,strong)CCTabBar    *tabBar;
@end

@implementation CCTabBarController
@dynamic tabBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar = [[CCTabBar alloc] init];
    [self.tabBar.centerBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //设置背景颜色不透明
    self.tabBar.translucent = NO;
    //利用KVC,将自定义tabBar,赋给系统tabBar
    [self setValue:self.tabBar forKeyPath:@"tabBar"];
    
    [self addChildViewControllers];
}
//添加子控制器
- (void)addChildViewControllers{
    HomeController *homeVC = [[HomeController alloc] init];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"tab-recommend"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-recommend-active"];

    MoreController *moreVC = [[MoreController alloc] init];
    moreVC.tabBarItem.title = @"更多";
    moreVC.tabBarItem.image = [UIImage imageNamed:@"tab-explore"];
    moreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-explore-active"];
    
    //不设置图片,先占位
    DiscoverController *discoverVC = [[DiscoverController alloc] init];
    discoverVC.tabBarItem.title = @"社区";

    DIYController *diyVC = [[DIYController alloc] init];
    diyVC.tabBarItem.title = @"工具";
    diyVC.tabBarItem.image = [UIImage imageNamed:@"tab-social"];
    diyVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-social-active"];

    MyController *myVC = [[MyController alloc] init];
    myVC.tabBarItem.title = @"我的";
    myVC.tabBarItem.image = [UIImage imageNamed:@"tab-mine"];
    myVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-mine-active"];

    MyNavigationController *navHome = [[MyNavigationController alloc] initWithRootViewController:homeVC];
    MyNavigationController *navMore = [[MyNavigationController alloc] initWithRootViewController:moreVC];
    MyNavigationController *navDiscover = [[MyNavigationController alloc] initWithRootViewController:discoverVC];
    MyNavigationController *navDIY = [[MyNavigationController alloc] initWithRootViewController:diyVC];
    MyNavigationController *navMy = [[MyNavigationController alloc] initWithRootViewController:myVC];
    NSArray *itemArrays   = @[navHome,navMore,navDiscover,navDIY,navMy];
    self.viewControllers  = itemArrays;
    self.tabBar.tintColor = [UIColor colorNamed:@"indicatorColor"];
}
- (void)buttonAction{
    //关联中间按钮
    self.selectedIndex = 2;
    //播放动画
    [self rotationAnimation];
}
//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 2){
        //选中中间的按钮
        [self rotationAnimation];
    }else {
        [self.tabBar.centerBtn.layer removeAllAnimations];
    }
}
//旋转动画
- (void)rotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*0.5];
    rotationAnimation.duration = 0.3;
    rotationAnimation.repeatCount = DOMAIN;
    [self.tabBar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}
@end

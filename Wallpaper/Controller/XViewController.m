//
//  XViewController.m
//  Wallpaper
//
//  Created by 李伟 on 2021/2/2.
//

#import "XViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Wallpaper-Swift.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LWVideoModel.h"
@interface XViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic) NSInteger height;

@property (nonatomic) NSInteger beginY;
///第一次按下
@property (nonatomic) BOOL isBeginScroll;
///开始结束滑动scroll动画
@property (nonatomic) BOOL isBeginAnimationScroll;

@property (nonatomic) BOOL isXiangHuaDong;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _scrollView.mj_header.automaticallyChangeAlpha = YES;
        _scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _scrollView.mj_footer.automaticallyChangeAlpha = YES;
        _scrollView.delegate = self;
       
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2.0)];

        [self loadResouses:0.0];
        
        [self.view addSubview:_scrollView];
        
        [self addObserver:self forKeyPath:@"isBeginScroll" options:NSKeyValueObservingOptionNew context:nil];
        

        [self loadResouses:_scrollView.frame.size.height];
    [_scrollView.mj_header beginRefreshing];
}

#pragma mark - 刷新数据
- (void)loadData {
    self.currentPage = 1;
    //发起网络请求
    NSString *urlString = @"https://2041a8770cfc5833.itqingjiao.com/api/index/index";
    NSDictionary *params = @{@"appkey": @"035d4cebaaf8bc9d9f5aa782368224ac", @"page": @(self.currentPage), @"pagesize": @20, @"video": @1};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        self.dataArray = [LWVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = error.localizedDescription;
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.0];
    }];
    
}

- (void)loadMore {
    self.currentPage = self.currentPage + 1;
    //发起网络请求
    NSString *urlString = @"https://2041a8770cfc5833.itqingjiao.com/api/index/index";
    NSDictionary *params = @{@"appkey": @"035d4cebaaf8bc9d9f5aa782368224ac", @"page": @(self.currentPage), @"pagesize": @20, @"video": @1};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSArray *temp = [LWVideoModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.dataArray addObjectsFromArray:temp];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = error.localizedDescription;
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.0];
    }];
}

-(void)loadResouses:(float) startY{
    
    ///startY为当前屏幕显示的位置起始y坐标
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90 - 22, startY+_scrollView.frame.size.height - 377 - 9, 90, 9)];
    
    [text setText:@"1024"];
    
    [text setFont:[UIFont systemFontOfSize:12]];
    
    [text setTextAlignment:NSTextAlignmentRight];
    
    [text setTextColor:[UIColor whiteColor]];
    
    [self.scrollView addSubview:text];
 
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    ///开始滑动scrollView
    self.isBeginScroll = YES;

    ///开始滑动scrollView的位置
    self.beginY = scrollView.contentOffset.y;

}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    ///停下自动滑动scrollView
    [self.scrollView setContentOffset:velocity animated:YES];
    
    ///结束滑动scrollView
    self.isBeginScroll = NO;
    ///开始滑动动画
    self.isBeginAnimationScroll = YES;
    
    if (fabs(velocity.y) > 0.3) {
        
        self.isXiangHuaDong = true;
        
    }else{
        
        self.isXiangHuaDong = false;
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    if (!decelerate) {
        [self.scrollView setContentOffset:CGPointMake(0, self.beginY) animated:YES];
    }


}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    ///结束滑动scrollView
    self.isBeginScroll = NO;
    ///开始滑动动画
    self.isBeginAnimationScroll = YES;
    
    
    
}


///结束滑动动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.isBeginAnimationScroll) {
        
        CGFloat currentY = scrollView.contentOffset.y;
        
        NSInteger page = currentY/_scrollView.frame.size.height;
       
        ///在这里可以处理滑动结束一些视频自动播放逻辑
        
    }
    
    self.isBeginAnimationScroll = NO;

}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if (!self.isBeginScroll) {
        
        CGFloat offSetY = self.scrollView.contentOffset.y;
        
        if (!(fabs(offSetY - self.beginY) > _scrollView.frame.size.height/3.0) && !self.isXiangHuaDong) {
            
            [self.scrollView setContentOffset:CGPointMake(0, self.beginY) animated:YES];
            
            return ;
        }
        
        NSInteger scale = (int)(offSetY/_scrollView.frame.size.height);
   
        if (offSetY >= self.beginY) {
            
            if ((scale+1)*_scrollView.frame.size.height + _scrollView.frame.size.height >= _scrollView.contentSize.height) {
                [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _scrollView.contentSize.height + _scrollView.frame.size.height)];
            }
            
            
            
            ///每次滑动scrollView自动扩容
            [self.scrollView setContentOffset:CGPointMake(0, (scale+1)*_scrollView.frame.size.height) animated:YES];
            
            [self loadResouses:(scale+2)*_scrollView.frame.size.height];
    
        }
        
        if (offSetY < self.beginY) {
            
            if (self.beginY >= self.view.frame.size.height){
       
                [self.scrollView setContentOffset:CGPointMake(0, (scale)*_scrollView.frame.size.height) animated:YES];

            }
            
        }
        
    }
    
}



@end

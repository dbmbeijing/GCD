//
//  ViewController.m
//  GCD的简单使用
//
//  Created by User on 15/11/9.
//  Copyright © 2015年 User. All rights reserved.
//

// 全局的宽/高
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height

// 全局的行数/列数
#define kROWS 5
#define kCOLS 3

// 格子数
#define kNUMBERS kROWS*kCOLS

// 全局的间隙
#define kMARGIN 3

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 计算每一个格子的宽度和高度
    
    CGFloat imageW = (kWIDTH - kMARGIN*(kCOLS +1))/kCOLS;
    
    CGFloat imageH = (kHEIGHT - kMARGIN*(kROWS + 1))/kROWS;
    
    // 注意 : 保证串行队列的唯一性!
//    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0; i < kNUMBERS; i++) {
        
        // 行数
        int row = i / kCOLS;
        // 列数
        int col = i % kCOLS;
        
        CGFloat imageX = kMARGIN + (kMARGIN + imageW)*col;
        
        CGFloat imageY = kMARGIN + (kMARGIN + imageH)*row;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        
        imageView.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:imageView];
        
        
        // 图片下载地址
        NSString *urlString = [NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%d.jpg",i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        // 图片一点一点的显示出来.
        //[imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload];
        
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, imageW, 2)];
        
        progress.tintColor = [UIColor greenColor];
        
        [imageView addSubview:progress];
        
        // 设置进度条.
        [imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            // receivedSize:当前得到的数据大小
            
            // expectedSize:数据的总大小
            
            // 设置进度条
            progress.progress = (double)receivedSize/expectedSize;
            
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"操作完成");
            //
        }];
    }
    
    

    
}


@end

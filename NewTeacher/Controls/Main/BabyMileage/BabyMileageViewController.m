//
//  BabyMileageViewController.m
//  NewTeacher
//
//  Created by szl on 15/11/30.
//  Copyright (c) 2015年 songzhanglong. All rights reserved.
//

#import "BabyMileageViewController.h"
#import "MileageStudentModel.h"
#import "NSString+Common.h"
#import "PlayMileageViewController.h"
#import "PlayMileageListController.h"

@interface BabyMileageViewController ()

@end

@implementation BabyMileageViewController
{
    UIImageView *navBarHairlineImageView;
    UILabel *_numLab,*_centerLab;
    UIImageView *_headerImgView;
    UIButton *_playBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showNewBack = YES;
    UIBarButtonItem *item = [self.navigationItem.leftBarButtonItems lastObject];
    UIButton *leftBut = (UIButton *)[[item.customView subviews] firstObject];
    [leftBut setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileageBackN" ofType:@"png"]] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileageBackH" ofType:@"png"]] forState:UIControlStateHighlighted];
    
    self.titleLable.textColor = [UIColor whiteColor];
    
    //top
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, winSize.width, 180)];
    [topImg setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileageTopBg" ofType:@"png"]]];
    [self.view addSubview:topImg];
    
    //head
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake((winSize.width - 54) / 2, 10, 54, 54)];
    _headerImgView = headImg;
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 27;
    [self.view addSubview:headImg];
    
    //name + birthday
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(50, headImg.frame.origin.y + headImg.frame.size.height + 10, winSize.width - 100, 22)];
    _centerLab = nameLab;
    [nameLab setFont:[UIFont boldSystemFontOfSize:18]];
    [nameLab setTextAlignment:1];
    [nameLab setTextColor:[UIColor whiteColor]];
    [nameLab setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:nameLab];
    
    UILabel *birthday = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.frame.origin.x, nameLab.frame.origin.y + nameLab.frame.size.height, nameLab.frame.size.width, 16)];
    [birthday setFont:[UIFont systemFontOfSize:12]];
    [birthday setBackgroundColor:[UIColor clearColor]];
    [birthday setTextColor:[UIColor whiteColor]];
    [birthday setTextAlignment:1];
    _numLab = birthday;
    [self.view addSubview:birthday];
}

- (void)resetNumText:(NSString *)str
{
    [_numLab setText:str];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        navBar.barTintColor = CreateColor(82, 78, 128);
    }
    else
    {
        navBar.tintColor = CreateColor(82, 78, 128);
    }
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_mileageStu) {
        [_centerLab setText:_mileageStu.real_name];
        NSDate *dateBir = [NSString convertStringToDate:_mileageStu.birthday];
        NSString *birStr = [NSString stringByDate:@"yyyy年MM月dd日" Date:dateBir];
        [_numLab setText:birStr];
        NSString *url = _mileageStu.face_school;
        if (![url hasPrefix:@"http"]) {
            url = [G_IMAGE_ADDRESS stringByAppendingString:url ?: @""];
        }

        [_headerImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"s21@2x" ofType:@"png"]]];
    }
    else
    {
        if (!_playBtn) {
            [self createRightButton];
            [self addPlayBtn];
        }
        
        DJTUser *userInfo = [DJTGlobalManager shareInstance].userInfo;
        [_centerLab setText:userInfo.classname];
        NSString *url = userInfo.face;
        if (![url hasPrefix:@"http"]) {
            url = [G_IMAGE_ADDRESS stringByAppendingString:url ?: @""];
        }
        [_headerImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"s21@2x" ofType:@"png"]]];
    }
}

- (void)addPlayBtn
{
    //play
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn = playBtn;
    [playBtn setFrame:CGRectMake(SCREEN_WIDTH - 77, 22.5, 77, 29)];
    [playBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileagePlay" ofType:@"png"]] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        navBar.barTintColor = [UIColor whiteColor];
    }
    else
    {
        navBar.tintColor = CreateColor(233, 233, 233);
    }
    
    navBarHairlineImageView.hidden = NO;
}

- (void)createRightButton{
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 30.0, 30.0);
    [moreBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileageMenuN" ofType:@"png"]] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mileageMenuH" ofType:@"png"]] forState:UIControlStateHighlighted];
    [moreBtn addTarget:self action:@selector(addTheme:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;//这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,backBarButtonItem];
}

- (void)playVideo:(id)sender{
    PlayMileageListController *playController = [[PlayMileageListController alloc] init];
    [self.navigationController pushViewController:playController animated:YES];
}

- (void)addTheme:(id)sender
{
    AddThemeViewController *addTheme = [[AddThemeViewController alloc] init];
    addTheme.themeType = MileageThemeAdd;
    addTheme.delegate = (MileageViewController *)[self.subControls objectAtIndex:0];
    [self.navigationController pushViewController:addTheme animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

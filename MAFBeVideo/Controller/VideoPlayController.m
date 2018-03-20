//
//  VideoPlayController.m
//  BEVideo
//
//  Created by FM on 15/12/12.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "VideoPlayController.h"
#import "KVideoCloudView.h"
#import "KVideoOptionPortView.h"
#import "KVideoOptionView.h"
#import "RealTimePlayer.h"
#import "KGLVideoControl.h"
#import <MBProgressHUD.h>
#import "Utils.h"
#import "PlayControl.h"
#import "UIView+ConstraintHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "YTKKeyValueStore.h"
#import "MAFMonitorSettingVC.h"
#import "EventBus.h"
#import "EventSubscriber.h"


AVAudioPlayer *avAudioPlayer;

@interface VideoPlayController()<PlayerControlDelegate,KVideoOptionPortDelegate, EventSyncSubscriber>

/**
 摄像头model
 */
@property (nonatomic, copy) CameraNode *cameraNode;
/**
 全屏按钮
 */
@property (nonatomic, strong) UIButton *fullButton;
/**
 全屏返回按钮
 */
@property (nonatomic, strong) UIButton *backBtnLandscape;
/**
 视频容器视图
 */
@property (nonatomic, strong) UIView *videoView;
/**
 流量框图片
 */
@property (nonatomic, strong) UIImageView *streamIcon;
/**
 流量框label
 */
@property (nonatomic, strong) UILabel *streamLabel;
/**
 视频控制器(播放器)
 */
@property (nonatomic, strong) KGLVideoControl *kGLVideoControl;
/**
 操作条(声音,时间,云镜/操作)
 */
@property (nonatomic, strong) KVideoOptionView *showControllerView;
/**
 操作区域(录屏/截图/按住说话)
 */
@property (nonatomic, strong) KVideoOptionPortView *optionPortView;
/**
 操作区域(焦距/焦点/反向调整)
 */
@property (nonatomic, strong) KVideoCloudView *optionCloudView;
@property (nonatomic, strong) MBProgressHUD *mbpHud;

@property (nonatomic, assign) BOOL isFullscreenMode;

@property (nonatomic, assign) BOOL snapTasking;
@property (nonatomic, assign) CGRect navigationBarRect;


@property (nonatomic, strong) UIPanGestureRecognizer *pan;

/**
 时间格式
 */
@property (nonatomic, strong) NSDateFormatter *formatter;
/**
 是否竖屏
 */
@property (nonatomic, assign) BOOL isPortrait;

@end

@implementation VideoPlayController

#pragma mark 懒加载

- (UIButton *)fullButton {
    if (_fullButton == nil) {
        _fullButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _fullButton.frame = CGRectMake(0,0,50,50);
        [_fullButton setImage:[UIImage imageNamed:@"video_full_screen_normal"] forState:UIControlStateNormal];
        [_fullButton setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -10)];
        [_fullButton addTarget:self action:@selector(onFullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullButton;
}
- (UIButton *)backBtnLandscape {
    if (_backBtnLandscape == nil) {
        _backBtnLandscape = [[UIButton alloc] init];
        _backBtnLandscape.frame = CGRectMake(15, 15, 44, 44);
        _backBtnLandscape.hidden = YES;
        [_backBtnLandscape setBackgroundImage:[UIImage imageNamed:@"btn_back_bg"] forState:UIControlStateNormal];
        [_backBtnLandscape addTarget:self action:@selector(ForcePortrait) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtnLandscape;
}
- (UILabel *)streamLabel {
    if (_streamLabel == nil) {
        _streamLabel = [[UILabel alloc]init];
        _streamLabel.textColor = [UIColor whiteColor];
        _streamLabel.textAlignment = NSTextAlignmentCenter;
        _streamLabel.font = FONT(13);
        _streamLabel.adjustsFontSizeToFitWidth = YES;
        _streamLabel.layer.cornerRadius = 6;
        _streamLabel.layer.masksToBounds = YES;
        _streamLabel.backgroundColor = RGBACOLOR(20.0,155.0,255.0,1.0);//20 155 255
    }
    return _streamLabel;
}
- (UIImageView *)streamIcon {
    if (_streamIcon == nil) {
        _streamIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stream_text_bg"]];
    }
    return _streamIcon;
}
- (UIView *)videoView {
    if (_videoView == nil) {
        /// 宽高比  16:9
        CGFloat videoHeight = 0.44 * SCREEN_HEIGHT;
        CGFloat videoWidth = videoHeight * 1.777;
        _videoView = [[UIView alloc] initWithFrame:CGRectMake(0,64,videoWidth,0.44 * SCREEN_HEIGHT)];
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_videoView addGestureRecognizer:self.pan];
    }
    return _videoView;
}
- (KGLVideoControl *)kGLVideoControl {
    if (_kGLVideoControl == nil) {
        CGFloat videoHeight = 0.44 * SCREEN_HEIGHT;
        CGFloat videoWidth = videoHeight * 1.777;
        _kGLVideoControl = [[KGLVideoControl alloc] initWithCameraNode:self.cameraNode];
        _kGLVideoControl.view.frame = CGRectMake((SCREEN_WIDTH - videoWidth) / 2.0, 64, videoWidth, videoHeight);
    }
    return _kGLVideoControl;
}
/**
 操作条(声音,时间,云镜/操作)
 */
- (KVideoOptionView *)showControllerView {
    if (_showControllerView == nil) {
        _showControllerView = [[KVideoOptionView alloc] initWithFrame:CGRectMake(0,0.44 * SCREEN_HEIGHT + 64, SCREEN_WIDTH, 0.1 * SCREEN_HEIGHT)];
        _showControllerView.backgroundColor = kVideoOptionMuteBGColor;
    }
    return _showControllerView;
}
/**
 操作区域(录屏/截图/按住说话)
 */
- (KVideoOptionPortView *)optionPortView {
    if (_optionPortView == nil) {
        _optionPortView = [[KVideoOptionPortView alloc] init];
        _optionPortView.frame = CGRectMake(0, 0.45 * SCREEN_HEIGHT + 64, SCREEN_WIDTH, 0.46 * SCREEN_HEIGHT);
        _optionPortView.delegate = self;
        _optionPortView.hidden = YES;
    }
    return _optionPortView;
}
/**
 操作区域(焦距/焦点/方向调整)
 */
- (KVideoCloudView *)optionCloudView {
    if (_optionCloudView == nil) {
        _optionCloudView = [[KVideoCloudView alloc] initWithFrame:self.optionPortView.frame];
        _optionCloudView.camerId = self.cameraNode.nodeId;
        _optionCloudView.hidden = NO;
    }
    return _optionCloudView;
}
- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _formatter;
}
#pragma mark 初始化方法
-(instancetype)initWithCameraNode:(CameraNode *)cameraNode
{
    if(self = [super init]){
        _cameraNode = cameraNode;
    }
    return self;
}
#pragma mark 生命周期
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    self.isPortrait = YES;
    EVENT_SUBSCRIBE(self, @"monitorSetting");
    
    if(self.cameraNode == nil){
        self.mbpHud = [Utils createHUD];
        self.mbpHud.labelText = @"没有发现摄像机";
        [self.mbpHud hide:YES afterDelay:1];
    }
    
    [PlayControl getInstance].playerControlDelegate = self;
    
    [self initView];
    [self setupLayoutPortrait];
    [self initCallback];
}

#pragma mark 自定义方法
- (void)setNav {
    self.view.backgroundColor = kCommonBGColor;
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, 5, 40, 40)];
    la.text = self.cameraNode.name;
    la.font = [UIFont systemFontOfSize:NAVIGATION_FONT_SIZE];
    la.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = la;
    
    // 右边按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.fullButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setImage:IMAGED(@"QA_NavBack") forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 25)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)goBack {
    [[RealTimePlayer getInstance] stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kVideoOptionBGColor;
    self.navigationBarRect = self.navigationController.navigationBar.frame;
    
    [self addChildViewController:self.kGLVideoControl];
    [self.kGLVideoControl didMoveToParentViewController:self];
    [self.view addSubview:self.optionPortView];
    [self.view addSubview:self.optionCloudView];
    [self.view addSubview:self.showControllerView];
    [self.view addSubview:self.videoView];
    [self.videoView addSubview:self.kGLVideoControl.view];
    //    [self.kGLVideoControl showIndicatorViewWith:YES text:@"正在加载，请稍后..."];
    [self.view addSubview:self.backBtnLandscape];
    [self.view addSubview:self.streamLabel];
    [self.view addSubview:self.streamIcon];
}
/**
 初始化回调block
 */
-(void)initCallback
{
    VideoPlayController * __weak weakSelf = self;
    
    self.showControllerView.onClickListener = ^(TouchOptionType type){
        if(type == TouchEventSetting){
            Lg(@"--- 设置页面 ");
            MAFMonitorSettingVC *monitorSettingVC = [[MAFMonitorSettingVC alloc] init];
            [weakSelf.navigationController pushViewController:monitorSettingVC animated:YES];
        }else if(type == TouchEventOptionPort){
            Lg(@"----  optionPort --");
            [weakSelf toggleShowOptionView];
        }
    };
}
- (void)eventOccurred:(NSString *)eventName event:(Event *)event {
    if ([eventName isEqualToString:@"monitorSetting"]) {
        //        [[RealTimePlayer getInstance] startPlayerWithChannelid:self.cameraNode.nodeId];
    }
}
#pragma mark - 屏幕旋转
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self updateviewControllerConstraints];
    
}

-(void)updateviewControllerConstraints
{
    
    //横屏
    if(self.view.frame.size.width > self.view.frame.size.height)
    {
        if(!self.isPortrait)return;
        
        [self setupLayoutLandscape];
        
    }
    //竖屏
    else{
        
        if(self.isPortrait)return;
        
        [self setupLayoutPortrait];
    }
    
}


-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:[self.kGLVideoControl.view superview]];
    [self.kGLVideoControl.view setCenter:CGPointMake([self.kGLVideoControl.view center].x + translation.x,[self.kGLVideoControl.view center].y)];
    [sender setTranslation:(CGPoint){0, 0} inView:[self.kGLVideoControl.view superview]];
    [self adjustPortraitBound];
}

// 返回是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    /**
     *  要使 setStatusBarOrientation 生效，此处必须返回 NO
     */
    return NO;
}

// 返回支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


// 强制左横屏
- (void)ForceLandscapeLeft
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self setupLayoutLandscape];
    }];
}

// 强制竖屏
- (void)ForcePortrait
{
    self.isPortrait = YES;
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        self.view.transform = CGAffineTransformIdentity;
        [self setupLayoutPortrait];
    }];
}

#pragma mark - layout of landscape or portrait
// 横屏
-(void)setupLayoutLandscape
{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    self.backBtnLandscape.hidden = NO;
    
    self.videoView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    self.pan.enabled = NO;
    
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.kGLVideoControl.view.frame = self.videoView.frame;
    self.kGLVideoControl.canGesture = YES;
    
    self.streamLabel.frame = CGRectMake((SCREEN_HEIGHT - 50),self.videoView.frame.origin.y, 50, 20);
    self.streamIcon.frame = CGRectMake(self.streamLabel.frame.origin.x+3, self.streamLabel.frame.origin.y+4, 8, 12);
    
}
// 竖屏
-(void)setupLayoutPortrait
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    self.backBtnLandscape.hidden = YES;
    
    /// 宽高比  16:9
    CGFloat videoHeight = 0.44 * SCREEN_HEIGHT;
    CGFloat videoWidth = videoHeight * 1.777;
    
    self.pan.enabled = YES;
    
    self.navigationController.navigationBar.frame = self.navigationBarRect;
    
    self.optionCloudView.frame = self.optionPortView.frame;
    self.videoView.frame = CGRectMake(0,64,videoWidth,0.44 * SCREEN_HEIGHT);
    self.kGLVideoControl.view.frame = CGRectMake((SCREEN_WIDTH - videoWidth) / 2.0, 0,videoWidth,videoHeight);
    
    self.kGLVideoControl.canGesture = NO;
    
    self.streamLabel.frame = CGRectMake((SCREEN_WIDTH - 50), self.videoView.frame.origin.y, 50, 20);
    self.streamIcon.frame = CGRectMake(self.streamLabel.frame.origin.x+3, self.streamLabel.frame.origin.y+4, 8, 12);
    
    self.videoView.clipsToBounds = YES;
    
}

-(void)adjustPortraitBound
{
    CGFloat left = self.kGLVideoControl.view.frame.origin.x;
    CGFloat top = self.kGLVideoControl.view.frame.origin.y;
    
    CGFloat width = self.kGLVideoControl.view.frame.size.width;
    CGFloat height = self.kGLVideoControl.view.frame.size.height;
    
    if(left > 0)
    {
        left = 0;
    }
    else{
        if((left + width) < SCREEN_WIDTH)
        {
            left = SCREEN_WIDTH - width;
        }
    }
    
    self.kGLVideoControl.view.frame = CGRectMake(left, top, width, height);
}

#pragma mark - Option
-(void)onFullScreenAction:(id)sender
{
    if (self.isPortrait) {
        self.isPortrait = NO;
        [self ForceLandscapeLeft];
    } else {
        self.isPortrait = YES;
        [self ForcePortrait];
    }
}

-(void)toggleShowOptionView
{
    if(self.optionCloudView.hidden){
        self.optionCloudView.hidden = NO;
        self.optionPortView.hidden = YES;
    }else{
        self.optionCloudView.hidden = YES;
        self.optionPortView.hidden = NO;
    }
}



#pragma mark - 录音 对讲  截屏
-(void)onRecord
{
    AsyncTaks_Excute(^{
        [[PlayControl getInstance] toggleRecord];
    });
}

-(void)onAudio
{
    Lg(@"--- 对讲");
    
}

-(void)onSnap
{
    
    if(_snapTasking){
        return;
    }
    
    _snapTasking = true;
    AsyncTaks_Excute(^{
        [self takePicture];
        [[PlayControl getInstance] snapShot];
    });
}

//拍照
-(void)takePicture
{
    //从budle路径下读取音频文件　　轻音乐 - 萨克斯回家 这个文件名是你的歌曲名字,mp3是你的音频格式
    NSString *string = [[NSBundle mainBundle] pathForResource:@"1374" ofType:@"wav"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //初始化音频类 并且添加播放文件
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    //设置音乐播放次数  -1为一直循环
    avAudioPlayer.numberOfLoops = 1;
    
    [avAudioPlayer play];
}


#pragma mark - PlayControlDelegate


-(void)UpdateFlow:(int)downloadSpeed vfps:(int)vfps
{
    onUIThread((^{
        if(downloadSpeed < 1024)
        {
            //            [_streamView updateStreamText:[NSString stringWithFormat:@"%dK",downloadSpeed]];
            [self.streamLabel setText:[NSString stringWithFormat:@" %dK",downloadSpeed]];
            //            self.title = [NSString stringWithFormat:@"%dK",downloadSpeed];
        }else{
            CGFloat num = downloadSpeed / 1024.0;
            [self.streamLabel setText:[NSString stringWithFormat:@" %.2fM",num]];
            //            self.title = [NSString stringWithFormat:@"%.2fM",num];
        }
    }));
}

-(void)UpdateRecordStatus:(BOOL)isOpen msg:(NSString *)msg
{
    if(isOpen){
        onUIThread(^{
            [self.kGLVideoControl showRecordTime];
            
        });
    }else{
        onUIThread((^{
            [self.kGLVideoControl hideRecordTime];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }));
    }
}


-(void)UpdatePlaytime:(long)timestamp
{
    onUIThread(^{
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *currentDateStr = [self.formatter stringFromDate:confromTimesp];
        [self.showControllerView updateTime:currentDateStr];
    });
    
}

-(void)UpdateRecordTime:(long)time
{
    Lg(@"录像时间回调 %ld:",time);
    onUIThread(^{
        [self.kGLVideoControl updateRecordTime:time];
    });
}

-(void)UpdateSnapShot:(BOOL )result
{
    
    _snapTasking = false;
    Lg(@"--- 截屏成功？%mediaFiles%hhd:",result);
}


-(void)saveMediaFile:(id)identifier withTime:(NSString *)time withPlayerCmd:(PlayerCmd)cmd
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DATABASE_RECORD];
    [store createTableWithName:TABLE_NAME_RECORD];
    // 保存
    NSDictionary *user = @{@"identifier": identifier,@"time":time, @"name": _cameraNode.name, @"type":(cmd == SnapShot ? @"image" : @"video")};
    [store putObject:user withId:time intoTable:TABLE_NAME_RECORD];
    [store close];
}




@end

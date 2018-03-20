//
//  KGLVideoControl.m
//  BEVideo
//
//  Created by FM on 15/12/25.
//  Copyright © 2015年 BlueEye. All rights reserved.
//

#import "KGLVideoControl.h"
#import "GLView.h"
#import "RealTimePlayer.h"
#import "AppConfig.h"

@interface KGLVideoControl()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic,copy) CameraNode *camerNode;
@property (nonatomic,strong) PlayerGLView *playview;

@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UILabel *indicatorLabel;

@property (nonatomic,strong) UILabel *recordTimeLabel;

@property (nonatomic, assign) long recordTime;


@end

@implementation KGLVideoControl


-(instancetype)initWithCameraNode:(CameraNode *)cameraNode
{
    if(self = [super init]){
        _camerNode = cameraNode;
//        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredActive)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
    [self initViews];
    [self setupLayout];
    [self defineGestureRecognizer];//定义手势
}

-(void)initViews
{
    
    // player view
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    self.view.frame = CGRectMake(0,0, self.view.frame.size.width, 0.44 * SCREEN_HEIGHT);
    
    CGRect viewFrame = self.view.frame;
    
    _canGesture = NO;
    
    _playview = [[PlayerGLView alloc]initWithFrame:viewFrame];
    
    if (_playview == nil)
    {
        Lg(@"GLKView ======= nil\n");
    }
    else
    {
        Lg(@"GLKView ok \n");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    [self.view addSubview:_playview];
    
    [[RealTimePlayer getInstance]startPlayerWithChannelid:_camerNode.nodeId];
    
    screenWidth = 320;
    screenHeight = self.view.frame.size.height;
    
    
    //loading and tip view
//    self.view.layer.masksToBounds = YES; //没这句话它圆不起来
//    self.view.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = self.view.center;
    [self.view addSubview:_indicator]; //use progress bar instead..
    
    _indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    _indicatorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_indicatorLabel];
    
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.backgroundColor = [UIColor clearColor];
    _recordTimeLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _recordTimeLabel.textColor = [UIColor redColor];
    _recordTimeLabel.text = @"00:00:00";
    _recordTimeLabel.layer.cornerRadius = 3;
    _recordTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_recordTimeLabel];
    
    _recordTimeLabel.hidden = YES;
    
    
    //test 隐藏
    _indicator.hidden = YES;
    _indicatorLabel.hidden = YES;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    if([AppConfig getNodeMode]){
        [[RealTimePlayer getInstance] snapCameraPreview];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
//    [[RealTimePlayer getInstance] stopPlayer];
}

/**
 进入前台
 */
-(void)handleEnteredActive
{
    [[RealTimePlayer getInstance]startPlayerWithChannelid:_camerNode.nodeId];
}
/**
 进入后台
 */
-(void)handleEnteredBackground
{
    [[RealTimePlayer getInstance] stopPlayer];
}

-(void)setupLayout
{
    for (UIView *view in [self.view subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self.view addConstraint:setWidthMultiplier(_playview, self.view, 1.0)];
    [self.view addConstraint:setHeightMultiplier(_playview, self.view, 1.0)];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_indicator,_indicatorLabel,_recordTimeLabel);
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_indicator]-[_indicatorLabel]-|" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraint:HorizontalCenter(_indicatorLabel, self.view)];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_recordTimeLabel(<=30)]" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraint:setWidth(_recordTimeLabel, self.view, RESIZE_WIDTH(210))];
    [self.view addConstraint:HorizontalCenter(_recordTimeLabel, self.view)];
    
    if(!self.view.superview)return;
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if(view != nil){
        [_playview drawView];
    }
}

#pragma mark - public
-(void)showIndicatorViewWith:(BOOL)show text:(NSString *)text
{
    if (!show) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        _indicatorLabel.hidden = YES;
    }else{
        [_indicator startAnimating];
        _indicator.hidden = NO;
        _indicatorLabel.hidden = NO;
        _indicatorLabel.text = text;
    }
}

-(void)updateRecordTime:(long )time
{
    if (time > self.recordTime) {
        self.recordTime = time;
    }
    if(self.recordTime < 10){
        _recordTimeLabel.text = [NSString stringWithFormat:@"00:00:0%ld",self.recordTime];
    }
    else if(self.recordTime < 60){
        _recordTimeLabel.text = [NSString stringWithFormat:@"00:00:%ld",self.recordTime];
    }else if(self.recordTime < 600){
        _recordTimeLabel.text = [NSString stringWithFormat:@"00:0%ld:%ld",(self.recordTime / 60),(self.recordTime % 60)];
    }else if(self.recordTime < 3600){
        _recordTimeLabel.text = [NSString stringWithFormat:@"00:%ld:%ld",(self.recordTime / 60),(self.recordTime % 60)];
    }
}
-(void)hideRecordTime
{
    _recordTimeLabel.hidden = YES;
}

-(void)showRecordTime
{
    self.recordTime = 0;
    _recordTimeLabel.hidden = NO;
}

-(void)defineGestureRecognizer
{
    //pinchRecognizer
    _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
    [self.view addGestureRecognizer:_pinch];
    _scal =1;
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:_pan];
    _pan.enabled = NO;
    
//    //swipeGesture，left
//    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeLeft];
//    
//    //right
//    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRight];
//    
//    //up
//    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
//    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.view addGestureRecognizer:swipeUp];
//
//    //down
//    UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMove:)];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:swipeDown];

}



CGFloat lastScale;
CGPoint lastPoint;
-(void)handlePinches:(UIPinchGestureRecognizer *)sender {
    
    if(!_canGesture)
    {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _pan.enabled = NO;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        _pan.enabled = YES;
    }
    
    if ([sender numberOfTouches] < 2)
        return;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        lastScale = 1.0;
        lastPoint = [sender locationInView:self.view];
        
        CGPoint locationInView = [sender locationInView:self.view];
        CGPoint locationInSuperview = [sender locationInView:self.view.superview];
        
        self.view.layer.anchorPoint = CGPointMake(locationInView.x / self.view.bounds.size.width, locationInView.y / self.view.bounds.size.height);
        self.view.center = locationInSuperview;
    }

    // Scale
    CGFloat scale = 1.0 - (lastScale - sender.scale);
    
    if((scale * self.view.frame.size.height) < screenWidth){
        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        Lg(@"----  缩放 reset ------- view.x-y=%f width-height=%f",self.view.frame.origin,self.view.frame.size);
        return;
    }

    [self.view.layer setAffineTransform:
     CGAffineTransformScale([self.view.layer affineTransform],
                            scale,
                            scale)];
    lastScale = sender.scale;
    
    lastPoint = [sender locationInView:self.view];
    
    [self adjustBound];
    
    Lg(@"----  缩放  -------");
    
}

-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    if(!_canGesture)
    {
        _pan.enabled = NO;
        return;
    }

    
    CGPoint translation = [sender translationInView:[self.view superview]];
    [self.view setCenter:CGPointMake([self.view center].x + translation.x, [self.view center].y + translation.y)];
    [sender setTranslation:(CGPoint){0, 0} inView:[self.view superview]];
    
    [self adjustBound];
    
    Lg(@"-----  拖动 --------");

}

///横屏状态的手势
-(void)adjustBound
{
    CGFloat left = self.view.frame.origin.x;
    CGFloat top = self.view.frame.origin.y;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    if(width > SCREEN_HEIGHT)
    {
        if(left > 0)
            left = 0;
        else if((left + width) < SCREEN_HEIGHT)
        {
            left = SCREEN_HEIGHT - width;
        }
    }else{
        if(left < 0)
            left = 0;
        else if((left + width) > SCREEN_HEIGHT)
            left = SCREEN_HEIGHT - width;
    }
    
    if (height > SCREEN_WIDTH) {
        if(top > 0)
            top = 0;
        else if((top + height) < SCREEN_WIDTH)
            top = SCREEN_WIDTH - height;
    }else{
        if(top < 0)
            top = 0;
        else if ((top + height) > SCREEN_WIDTH)
            top = SCREEN_WIDTH - height;
    }
    self.view.frame = CGRectMake(left, top, width, height);
}


@end

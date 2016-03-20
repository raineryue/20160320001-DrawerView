//
//  ViewController.m
//  20160320001-DrawerView
//
//  Created by Rainer on 16/3/20.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，并且会自动补齐前面的内容。
// 定义KVO键值宏，在宏中，＃标示会把后面的参数变成C语言字符串：以下把key变成C语言字符串
// 逗号表达式，只取最右边的值
// 如果把c语言字符串转OC字符串需要使用@符号来包装
#define keyPath(obj, key) @(((void)obj.key, #key))

@interface ViewController ()

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *mainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.添加子视图
    [self setupSubviews];
    
    // 2.添加手势
    [self setupGestureRecognizer];
    
    // 3.添加监听
    [self setupObserverAction];
}

/**
 *  添加子视图
 */
- (void)setupSubviews {
    // 1.创建左边视图
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    leftView.backgroundColor = [UIColor greenColor];
    
    self.leftView = leftView;
    
    [self.view addSubview:self.leftView];
    
    // 2.创建右边视图
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    rightView.backgroundColor = [UIColor blueColor];
    
    self.rightView = rightView;
    
    [self.view addSubview:self.rightView];
    
    // 3.创建主视图
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mainView.backgroundColor = [UIColor redColor];
    
    self.mainView = mainView;
    
    [self.view addSubview:self.mainView];
}

/**
 *  添加手势
 */
- (void)setupGestureRecognizer {
    // 1.创建拖拽手势并添加监听事件
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanGestureRecognizerAction:)];
    
    // 2.将拖拽添加到控制器视图上
    [self.view addGestureRecognizer:panGestureRecognizer];
}

/**
 *  拖拽手势事件处理
 */
- (void)viewPanGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取拖拽手势的移动点
    CGPoint movePoint = [panGestureRecognizer translationInView:self.view];
    
    // 2.位移主视图
    __block CGRect mainViewFrame = self.mainView.frame;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        // 2.1.让主视图位移
        mainViewFrame.origin.x += movePoint.x;
        
        self.mainView.frame = mainViewFrame;
    }];
    
    // 3.复位手势的移动点
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}

/**
 *  添加监听
 */
- (void)setupObserverAction {
    // 给主视图添加一个frame的控制器监听
    [self.mainView addObserver:self forKeyPath:keyPath(self.mainView, frame) options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  监听器事件处理
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@", NSStringFromCGRect(self.mainView.frame));
    
    // 判断当主视图frame的x大于0说明在向右滑动，那么需要隐藏右边视图
    if (self.mainView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    } else if (self.mainView.frame.origin.x < 0) {    // 判断当主视图frame的x小于0说明在向左滑动，那么需要显示右边视图
        self.rightView.hidden = NO;
    }
}

/**
 *  对象销毁时掉用方法
 */
- (void)dealloc {
    [self.mainView removeObserver:self forKeyPath:@"frame"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

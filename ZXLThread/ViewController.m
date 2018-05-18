//
//  ViewController.m
//  ZXLThread
//
//  Created by 张小龙 on 2018/5/18.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ViewController.h"
#import "ZXLThread.h"

@interface ViewController ()
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong)UIButton * pasueBtn;
@property (nonatomic,strong)UIButton * resumeBtn;
@property (nonatomic,strong)ZXLThread * thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 200, 140, 40);
    rect.origin.x = (self.view.frame.size.width - rect.size.width)/2;
    
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.frame = rect;
        [self.view addSubview:_textLabel];
    }
    
    rect.origin.y += rect.size.height + 20;
    if (_pasueBtn == nil) {
        _pasueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pasueBtn.backgroundColor = [UIColor blackColor];
        _pasueBtn.layer.cornerRadius = 6.0f;
        _pasueBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_pasueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pasueBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_pasueBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _pasueBtn.frame = rect;
        [self.view addSubview:_pasueBtn];
    }
    
    rect.origin.y += rect.size.height + 20;
    if (_resumeBtn == nil) {
        _resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resumeBtn.backgroundColor = [UIColor blackColor];
        _resumeBtn.layer.cornerRadius = 6.0f;
        _resumeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_resumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resumeBtn setTitle:@"继续" forState:UIControlStateNormal];
        [_resumeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _resumeBtn.frame = rect;
        [self.view addSubview:_resumeBtn];
    }
    
    self.thread = [ZXLThread currentThread];
    NSArray *ayName = @[@"张一",@"张二",@"张三",@"张四",@"张五",@"张六",@"张七",@"张八",@"张九",@"张十"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textLabel.text = ayName[i%10];
            });
            i++;
            if ([self.thread waitSignal]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textLabel.text = [NSString stringWithFormat:@"中奖的是%@",ayName[i%10]];
                });
                [self.thread wait];
            }
        }
    });
}

-(void)onButton:(id)sender{

    if (sender == _pasueBtn) {
        [self.thread sendWaitSignal];
    }
    
    if (sender == _resumeBtn) {
        [self.thread signal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

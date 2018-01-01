//
//  ViewController.m
//  ZoombieDemo
//
//  Created by liusilan on 2017/12/29.
//  Copyright © 2017年 douyu. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()
@property (nonatomic, assign) Test *test;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Test *t = [Test new];
    _test = t;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    [_test test];
}

@end

//
//  ViewController.m
//  AppDemo
//
//  Created by ZP on 2021/5/13.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

int sum(int a,int b) {
    return a + b;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"sum result: %d",sum(10, 20));
}

@end

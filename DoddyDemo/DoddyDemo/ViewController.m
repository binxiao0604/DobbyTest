//
//  ViewController.m
//  DoddyDemo
//
//  Created by ZP on 2021/5/10.
//

#import "ViewController.h"
#import <DobbyX/dobby.h>
#import <mach-o/dyld.h>

@interface ViewController ()

@end

@implementation ViewController


//sum 函数地址 偏移值： PAGEZERO（0x100000000） + offset（0x5C70），这里用 uintptr_t 类型是为了方便计算。
static uintptr_t sum_address_offset = 0x100005D08;

+ (void)load {
    //Hook sum
//    DobbyHook(sum, HP_sum, (void *)&sum_p);
    //Hook NSLog
//    DobbyHook(NSLog, HP_NSLog, (void *)&NSLog_p);
    //地址hook
    //获取ASLR，相当于rebase
    uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
    uintptr_t sum_address = sum_address_offset + slide;
    NSLog(@"sum_address_offset:%p\nslide:%p\nsum_address:%p",(void *)sum_address_offset,(void *)slide,(void *)sum_address);
    DobbyHook((void *)sum_address, HP_sum, (void *)&sum_p);
}



- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark ---Hook Sum---
//要Hook的函数
int sum(int a, int b){
    return  a + b;
}

//新函数
int HP_sum(int a,int b) {
    NSLog(@"before hook: %d + %d = %d",a,b,sum_p(a,b));
    return a - b;
}

//原函数指针
static int(*sum_p)(int a,int b);

#pragma mark ---Hook NSLog---
//新函数
void HP_NSLog(NSString *format, ...) {
    NSLog_p([format stringByAppendingString:@"\nHook Success"]);
}

//原函数指针
static void(*NSLog_p)(NSString *format, ...);


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"after hook: %d + %d = %d",10,20,sum(10, 20));
    //    NSLog(@"HotpotCat");
//    DobbyHook(sum, HP_sum, (void *)&sum_p);
    NSLog(@"hook: %d + %d = %d",10,20,sum(10, 20));
}

@end

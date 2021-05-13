//
//  HPInject.m
//  HPHook
//
//  Created by ZP on 2021/5/13.
//

#import "HPInject.h"
#import <DobbyX/dobby.h>
#import <mach-o/dyld.h>

@implementation HPInject

//sum 函数地址 偏移值： PAGEZERO（0x100000000） + offset（0x5E54），这里用 uintptr_t 类型是为了方便计算。
//static uintptr_t sum_address_offset = 0x100005E54;
//swift
static uintptr_t sum_address_offset = 0x100006650;

+ (void)load {
    //获取ASLR，相当于rebase
    uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
    uintptr_t sum_address = sum_address_offset + slide;
    NSLog(@"sum_address_offset:%p\nslide:%p\nsum_address:%p",(void *)sum_address_offset,(void *)slide,(void *)sum_address);
    DobbyHook((void *)sum_address, HP_sum, (void *)&sum_p);
}

//要Hook的函数
int sum(int a, int b){
    return  a + b;
}

//新函数
int HP_sum(int a,int b) {
    NSLog(@"Hook Success");
    return sum_p(a,b);
}

//原函数指针
static int(*sum_p)(int a,int b);


@end

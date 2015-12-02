//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 每次只要文本框的文字一改变,在前面拼接xmg
    
    //  RACStream * (^RACStreamBindBlock)(id value, BOOL *stop)
    //  RACStream *(^)(id value, BOOL *stop)
    RACSignal *bindSignal = [_textField.rac_textSignal bind:^RACStreamBindBlock{
        // 绑定信号被订阅就会来这
        // block调用时刻:只要一个源信号被绑定就会调用.表示信号绑定完成
        // block做事情:
        NSLog(@"源信号被绑定");
        return ^RACStream *(id value, BOOL *stop){
            // RACStreamBindBlock什么时候调用:每次源信号发出内容,就会调用这个block
            // value:源信号发出的内容
            NSLog(@"源信号发出的内容:%@",value);
            
            // RACStreamBindBlock作用:在这个block处理源信号的内容
            value = [NSString stringWithFormat:@"xmg%@",value];
            
            // block返回值:信号(把处理完的值包装成一个信号,返回出去)
            
            // 创建一个信号,并且这个信号的传递的值是我们处理完的值,value
            return [RACReturnSignal return:value];
        };
        
    }];
    
    // 订阅绑定信号,不在是源信号
    [bindSignal subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    
    // 执行流程
    /*
        1.文字改变源信号
        2.绑定源信号,[_textField.rac_textSignal bind]
        * 调用bind返回绑定好的信号,didSubscribe
        3.订阅绑定信号
            * 创建订阅者
            * 调用绑定信号的didSubscribe
        4.执行绑定信号didSubscribe
        5.执行bind方法传入的block
        6.订阅源信号
        7.只要源信号一发出内容,就会调用id signal = bindingBlock(x, &stop);
            * signal:把值处理完的信号
        
     */
    
}



- (void)signal
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"123"];
        return nil;
    }] ;
    
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

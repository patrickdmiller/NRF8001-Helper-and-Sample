//
//  ViewController.m
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nrf8001 = [[NRF8001Delegate alloc] init];
    [nrf8001 setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** delegate */
-(void)newMessageAvailable:(NSString *)msg{
    NSLog(@"Received a message: %@", msg);
}

-(void)onConnected{
    NSLog(@"CONNECTED");
}

-(void)onDisconnected{
    NSLog(@"DISCONNECTED");
}
- (IBAction)ping:(id)sender {
    [nrf8001 sendMessage:@"PING!"];
}
@end

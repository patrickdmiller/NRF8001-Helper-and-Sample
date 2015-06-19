//
//  NRF8001Delegate.m
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import "NRF8001Delegate.h"

@implementation NRF8001Delegate

-(id) init{
    self = [super init];
    nrf8001 = [NRF8001 sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNRFString:) name:@"NRFString" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNRFStatus:) name:@"NRFStatus" object:nil];
    return self;
}

-(void)handleNRFString:(NSNotification *) notification{
    if([[notification userInfo] objectForKey:@"inString"]!=nil){
        [self.delegate newMessageAvailable:[[notification userInfo] objectForKey:@"inString"]];
    }
}

-(void)handleNRFStatus:(NSNotification *) notification{
    if([[notification userInfo] objectForKey:@"inStatus"]!=nil){
        if([[[notification userInfo] objectForKey:@"inStatus"] boolValue]){
            [self.delegate onConnected];
        }else{
            [self.delegate onDisconnected];
        }
    }
}

-(void)sendMessage:(NSString *)msg{
    [nrf8001 writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
}
@end

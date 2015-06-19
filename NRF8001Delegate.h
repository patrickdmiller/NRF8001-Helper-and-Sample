//
//  NRF8001Delegate.h
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRF8001.h"


@protocol NRF8001Delegate <NSObject>
@required
-(void) newMessageAvailable:(NSString*)msg;
-(void) onConnected;
-(void) onDisconnected;
@end

@interface NRF8001Delegate : NSObject {
    id <NRF8001Delegate> delegate;
    NRF8001 *nrf8001;
}

@property(nonatomic, retain) id delegate;

-(void)sendMessage:(NSString*)msg;

@end

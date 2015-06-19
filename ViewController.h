//
//  ViewController.h
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRF8001Delegate.h"

@interface ViewController : UIViewController <NRF8001Delegate>{
    NRF8001Delegate* nrf8001;
}

- (IBAction)ping:(id)sender;

@end


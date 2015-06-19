//
//  NRF8001.h
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define UART_SERVICE_ID_STRING @"6e400001-b5a3-f393-e0a9-e50e24dcca9e"
#define TX_CHARACTERISTIC_ID_STRING @"6e400002-b5a3-f393-e0a9-e50e24dcca9e"
#define RX_CHARACTERISTIC_ID_STRING @"6e400003-b5a3-f393-e0a9-e50e24dcca9e"


@interface NRF8001 : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>{
    NSMutableString *inString;
}

@property (nonatomic) CBCentralManager *centralManager;
@property (nonatomic) CBPeripheral *peripheral;
@property (nonatomic) CBUUID *serviceIDUart;
@property (nonatomic) CBService *serviceUart;
@property (nonatomic) CBUUID *characteristicIDTX;
@property (nonatomic) CBUUID *characteristicIDRX;
@property (nonatomic) CBCharacteristic *characteristicTX;
@property (nonatomic) CBCharacteristic *characteristicRX;
@property (nonatomic) NSString   *connected;

+(id)sharedInstance;
- (void)writeData:(NSData*)data;
@end
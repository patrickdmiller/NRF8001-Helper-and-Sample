//
//  NRF8001.m
//  NRF8001
//
//  Created by Patrick Miller on 4/21/15.
//  Copyright (c) 2015 Patrick Miller. All rights reserved.
//

#import "NRF8001.h"

@implementation NRF8001

//singleton pattern
+(id)sharedInstance{
    static NRF8001 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    self = [super init];
    inString = [[NSMutableString alloc] initWithString:@""];
    self.serviceIDUart = [CBUUID UUIDWithString:UART_SERVICE_ID_STRING];
    self.characteristicIDRX = [CBUUID UUIDWithString:RX_CHARACTERISTIC_ID_STRING];
    self.characteristicIDTX = [CBUUID UUIDWithString:TX_CHARACTERISTIC_ID_STRING];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}

//handle an incoming message,
-(void)messageHandler{
    NSRange position = [inString rangeOfString:@"\n"];
    //if theres a newline, process it recursively (it may contain multiple lines). Otherwise, its an incomplete message
    if(position.location != NSNotFound){
        NSString *tmpString = [[NSString alloc] initWithString:[[[inString substringToIndex:position.location] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        [inString setString:[inString substringFromIndex:position.location+1]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NRFString" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:tmpString, @"inString", nil]];
        if([inString containsString:@"\n"]){
            [self messageHandler];
        }
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"-- BLE state OFF --");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"-- BLE state ON --");
        [self.centralManager scanForPeripheralsWithServices:@[self.serviceIDUart] options:nil];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"-- BLE state UNAUTHORIZED --");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"-- BLE state UNKNOWN --");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"-- BLE state UNSUPPORTED --");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        [self.centralManager stopScan];
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NRFStatus" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.connected], @"inStatus", nil]];
    NSLog(@"%@", self.connected);
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        self.serviceUart= service;
        [peripheral discoverCharacteristics:@[self.characteristicIDRX, self.characteristicIDTX] forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic : %@", characteristic);
        if([characteristic.UUID.UUIDString isEqualToString:self.characteristicIDTX.UUIDString]){
            self.characteristicTX = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"TX : %@", characteristic);
        }
        if([characteristic.UUID.UUIDString isEqualToString:self.characteristicIDRX.UUIDString]){
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristicRX = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"RX : %@", characteristic);
        }
    }
}

- (void)writeData:(NSData*)data {
    [self.peripheral writeValue:data forCharacteristic:self.characteristicTX type:CBCharacteristicWriteWithoutResponse];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //    NSLog(@"%@", characteristic.UUID);
    NSData *data = [characteristic value];
    NSString* parsed = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"-- debug got data : %@ = %@", data, parsed);
    if(parsed != nil)
        [inString appendString:parsed];
    if([inString containsString:@"\n"]){
        [self messageHandler];
    }
}
@end

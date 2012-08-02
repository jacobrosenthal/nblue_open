//
//  nBlue.h
//  nBlue 1.0
//
//  Created by DERIC KRAMER on 1/18/12.
//  Copyright (c) 2012 BlueRadios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BRDevice.h"

@class BRDevice;

enum {
    BRServiceNone = 0,          //This value should never be used for scan.  It will find no devices
    BRServiceBRSP = 1,          //All BRSP devices
    BRServiceAll = 4294967295   //All BlueRadios devices
}; 
typedef UInt32 BRService;
/**
 Set of methods to be implemented as delegates for nBlue library callbacks.
 */
@protocol nBlueDelegate <NSObject>
@optional
/**
 Method that is called everytime a device is found.  
 @param p CBPeripheral object from the CoreBluetooth.framework that can be used to initialize BRDevice objects
 */
/*!  Typical use case involves checking peripherals to determine what to do. */
-(void) deviceFound:(CBPeripheral*)p;
/**
  Method that is called when scan_nBlue has completed.  
 */
/*!  Use if you need to know when scanning is finished. */
-(void) scanComplete;
/**
 Method is called signifying the completion of a connect request
 @param p CBPeripheral object that has been connected
 @param error An NSError object containing the error response if the call to connect failed to connect
 If == nil then no error occured and the device is now connected
 */
/*!  Put code here to handle connect confirmations. */
-(void) didConnect:(CBPeripheral*)p error:(NSError*)error;
/**
 Method that is called when a device is disconnected.  
 @param p CBPeripheral object that has been disconnected
 @param error
 An NSError object containing the error response if the call to disconnectDevice failed
 If == nil then no error occured and the device is now disconnected
 */
/*!  Put code here to handle disconnect confirmations. */
-(void) didDisconnect:(CBPeripheral*)p error:(NSError*)error;
/**
 Fires when isInitialized == YES.  This is a good place to start scanning, connecting, etc
 */
/*!  Put code here to handle nBlue initialized. IE: scan_nBlue */
-(void) nBlueReady;

@end

/**
 The manager class for use with BlueRadios BLE modules.  
 */
@interface nBlue : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
}

/**
 The delegate used for all nBlue callbacks.
 */
@property (nonatomic, weak) id <nBlueDelegate> nBlueDelegate;
/**
 A list of peripherals found by the scan_nBlue method.
 */
@property (nonatomic, readonly, strong, getter=getPeripherals) NSArray *peripherals;
/**
 Is set to YES if the device is currently powered on and available to use. (initWithDelegate has been called and has completed)
 */
@property (nonatomic, readonly, getter=initialized) BOOL isInitialized;

/**
 Get the shared nBlue instance
 @return nBlue object as id
 */
+(id) shared_nBlue;
/**
 Get the shared nBlue instance
 @param delegate 
 Will set the nBlueDelegate in the shared instance 
 @return nBlue object as id
 */
+(id) shared_nBlue:(id<nBlueDelegate>)delegate;
/**
Initialize an instance of this class using this funtion
 @param delegate 
    The delegate that will receive nBlue events.
 @return nBlue object as id
 */
-(id) initWithDelegate:(id<nBlueDelegate>)delegate;
/**
 Used to scan for devices.
 @param timeout the desired time (in seconds) to scan for devices.
 @param num a BRService enum value indicating which BlueRadios devices to filter. 
 <br><b>BRServiceNone</b> - This value should never be used.  Will return no devices.
 <br><b>BRServiceBRSP</b> - Devices that support the BRSP service
 <br><b>BRServiceAll</b>  - All BlueRadios devices will be returned in scan
 */
-(void) scan_nBlue:(int)timeout ServiceFilter:(BRService)num;
/**
 Used to stop scanning for devices. (Cancels a previous scan_nBlue call before the specified timeout)
 */
-(void) stopScan_nBlue;
/**
 Get a peripheral that was previously found by a scan_nBlue
 @param uuid 
 A NSString object with the uuid of the peripheral to search for.
 EX: @"00000000-0000-0000-0000-000000000000"
 @return
 The CBPeripheral object found.  Returns NULL if no peripheral found.
 */
-(CBPeripheral*)getPeripheral:(NSString *)uuid;
/**
 Connects a BRDevice.
 @param d a BRDevice to connect.
 */
-(void) connectDevice:(BRDevice*)d;
/**
 Disconnects a peripheral.
 @param d a BRDevice to disconnect.
 */
-(void) disconnectDevice:(BRDevice*)d;
/**
 Disconnects all BRDevices opened by this application
 */
-(void) disconnectAll;
/**
 Gets an array of accepted service UUIDs.
 @param BRService mask used to generate the NSArray
 @return NSArray of CBUUID objects
 */
-(NSArray*)getAcceptedServices:(BRService)serviceFilter;

@end

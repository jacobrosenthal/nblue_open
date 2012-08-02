//
//  nBlue.m
//  sampleclient
//
//  Created by Jacob on 8/1/12.
//
//

#import "nBlue.h"


//The manager class for use with BlueRadios BLE modules.
@implementation nBlue

//The delegate used for all nBlue callbacks.
@synthesize nBlueDelegate = _nBlueDelegate;

// A list of peripherals found by the scan_nBlue method.
@synthesize peripherals = _peripherals;

//Is set to YES if the device is currently powered on and available to use. (initWithDelegate has been called and has completed
@synthesize isInitialized = _isInitialized;



//added by me
@synthesize CM;


//wraps didDiscoverPeripheral
/**
 Method that is called everytime a device is found.
 @param p CBPeripheral object from the CoreBluetooth.framework that can be used to initialize BRDevice objects
 */
/*!  Typical use case involves checking peripherals to determine what to do. */
-(void) deviceFound:(CBPeripheral*)p{
    

}

//must be some kind of timeout timer calling stopscan
/**
 Method that is called when scan_nBlue has completed.
 */
/*!  Use if you need to know when scanning is finished. */
-(void) scanComplete{
    
}

//wrapping didConnectPeripheral
/**
 Method is called signifying the completion of a connect request
 @param p CBPeripheral object that has been connected
 @param error An NSError object containing the error response if the call to connect failed to connect
 If == nil then no error occured and the device is now connected
 */
/*!  Put code here to handle connect confirmations. */
-(void) didConnect:(CBPeripheral*)p error:(NSError*)error{
    
    
}

//wrapping didDisconnectPeripheral
/**
 Method that is called when a device is disconnected.
 @param p CBPeripheral object that has been disconnected
 @param error
 An NSError object containing the error response if the call to disconnectDevice failed
 If == nil then no error occured and the device is now disconnected
 */
/*!  Put code here to handle disconnect confirmations. */
-(void) didDisconnect:(CBPeripheral*)p error:(NSError*)error{
    

}


/**
 Fires when isInitialized == YES.  This is a good place to start scanning, connecting, etc
 */
/*!  Put code here to handle nBlue initialized. IE: scan_nBlue */
-(void) nBlueReady{
    

}



/**
 Get the shared nBlue instance
 @return nBlue object as id
 */
+(id) shared_nBlue{
    //total guess
    return self;
}


/**
 Get the shared nBlue instance
 @param delegate
 Will set the nBlueDelegate in the shared instance
 @return nBlue object as id
 */
+(id) shared_nBlue:(id<nBlueDelegate>)delegate{
    
    // Persistent instance.
    static nBlue *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
    {
        return _default;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      _default = [[nBlue alloc] init];
                      _default.nBlueDelegate=delegate;
                      _default.CM = [[CBCentralManager alloc] initWithDelegate:_default queue:nil];

                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([nBlue class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[nBlue alloc] init];
            // private initialization goes here.
        }
    }
#endif
    return _default;
}


/**
 Initialize an instance of this class using this funtion
 @param delegate
 The delegate that will receive nBlue events.
 @return nBlue object as id
 */
-(id) initWithDelegate:(id<nBlueDelegate>)delegate{
    return self;
}


/**
 Used to scan for devices.
 @param timeout the desired time (in seconds) to scan for devices.
 @param num a BRService enum value indicating which BlueRadios devices to filter.
 <br><b>BRServiceNone</b> - This value should never be used.  Will return no devices.
 <br><b>BRServiceBRSP</b> - Devices that support the BRSP service
 <br><b>BRServiceAll</b>  - All BlueRadios devices will be returned in scan
 */
-(void) scan_nBlue:(int)timeout ServiceFilter:(BRService)num{
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];

    [self.CM scanForPeripheralsWithServices:nil options:nil]; // TODO: Limit to nblue

}


/**
 Used to stop scanning for devices. (Cancels a previous scan_nBlue call before the specified timeout)
 */
-(void) stopScan_nBlue{
    
    
}


/**
 Get a peripheral that was previously found by a scan_nBlue
 @param uuid
 A NSString object with the uuid of the peripheral to search for.
 EX: @"00000000-0000-0000-0000-000000000000"
 @return
 The CBPeripheral object found.  Returns NULL if no peripheral found.
 */
-(CBPeripheral*)getPeripheral:(NSString *)uuid{
    
    return nil;
}


/**
 Connects a BRDevice.
 @param d a BRDevice to connect.
 */
-(void) connectDevice:(BRDevice*)d{
    //scancontroller is the delegate? somehow device needs to be generic device or brdevice
    //[self setNBlueDelegate:[d deviceDelegate]];

    [CM connectPeripheral:d.cbPeripheral options:nil];
}


/**
 Disconnects a peripheral.
 @param d a BRDevice to disconnect.
 */
-(void) disconnectDevice:(BRDevice*)d{
    
    
}


/**
 Disconnects all BRDevices opened by this application
 */
-(void) disconnectAll{
    
    
}


/**
 Gets an array of accepted service UUIDs.
 @param BRService mask used to generate the NSArray
 @return NSArray of CBUUID objects
 */
-(NSArray*)getAcceptedServices:(BRService)serviceFilter{
    
    return nil;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

}







//going to put all did* here for CBCentralManagerDelegate--- CBPeripheralDelegate stuff seems split across this and device?
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [_nBlueDelegate didConnect:peripheral error:nil];

}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    //how the fuck do I get peripherals loaded if its read only? changed it
    if (!self.peripherals) //TODO: right now will only find one device, no?
        self.peripherals = [[NSArray alloc] initWithObjects:peripheral,nil];

    NSLog(@"didDiscoverPeripheral\r\n");
    [_nBlueDelegate deviceFound:peripheral];
}

/*
 *  @method UUIDSAreEqual:
 *
 *  @param u1 CFUUIDRef 1 to compare
 *  @param u2 CFUUIDRef 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compares two CFUUIDRef's
 *
 */

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}



- (void) scanTimer:(NSTimer *)timer {
    NSLog(@"Stopped Scanning\r\n");
    NSLog(@"Known peripherals : %d\r\n",[self->_peripherals count]);
}
@end

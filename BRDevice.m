//
//  BRDevice.m
//  sampleclient
//
//  Created by Jacob on 8/1/12.
//
//

#import "BRDevice.h"

@implementation BRDevice

//Returns true if the device is connected
@synthesize isConnected;

//A pointer to the CBPeripheral object that is associated with this decice
@synthesize cbPeripheral;

// The BRSP mode of the device. @see -(void) changeBrspMode:(DeviceMode)mode;
@synthesize mode;

// The delegate used for all BRDevice callbacks.  Note: Defaults to BRdevice class or child class used to connect
@synthesize deviceDelegate;


//just wrapping didConnectPeripheral--but thats a centralmanager property.. 
/**
 Method is called signifying the completion of a connect request
 @param error
 An NSError object containing the error response if the call to connect failed to connect
 If == nil then no error occured and the device is now connected
 */
-(void) didConnect:(NSError*)error{
    
    
}


//wrapping didDisconnectPeripheral
/**
 Method is called signifying the completion of a disconnect request
 @param error
 An NSError object containing an error response associated with a disconnect.
 */
-(void) didDisconnect:(NSError*)error{
    
    
}


//wrapping didUpdateValueForCharacteristic
/**
 Method is called everytime data is received from the BLE device.
 @param response
 An NSData object containing the data received.
 */
-(void) deviceResponse:(NSData *)response{
    
    
}


/**
 Method is called everytime the BRSP mode of the device changes
 @param mode
 An DeviceMode indicating what BRSP mode the device is in
 */
-(void) modeChanged:(DeviceMode)mode{
    
    
}



/**
 Initialize the BRDevice class with this method instead of init
 @param p an initialized peripheral object
 @return self as id
 */
-(id) initWithPeripheral:(CBPeripheral*)p{
    self.cbPeripheral=p;
    return self;
}

/**
 Connects this device.
 @param manager an initialized nBlue manager object
 Note: Can use [nBlue shared_nBlue] to use a shared singleton instance
 */
-(void) connect:(nBlue*)manager{
    [manager connectDevice:self];
}


/**
 Disconnects this device
 */
-(void) disconnect{
    
    
}


/**
 Sends a string to the device
 @param str a string to send to device.
 */
-(void) writeBrsp:(NSString*)str{
    
    
}


/**
 Changes modes of the BRSP service.
 @param mode an int used to set the mode of a device.
 1 = data mode
 2 = remote command mode
 */
-(void) changeBrspMode:(DeviceMode)mode{
    
    
}




//going to put some CBPeripheralDelegate stuff here as seems split across this and device?

@end

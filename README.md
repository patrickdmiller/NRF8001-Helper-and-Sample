# NRF8001 Helper

This makes using the Adafruit's NRF8001 very simple for the common task of sending and receiving strings over BLE.

### Setup

#### arduino 

Use the [BLE Echo](https://github.com/adafruit/Adafruit_nRF8001) example from Adafruit.

#### ios

Either use this as a sample project or add it to your project by doing the following:
* Add NRF8001.h/m and NRF8001Delegate.h/m to your project
* Add [NRF8001 sharedInstance] to AppDelegate.m didFinishLaunchingWithOptions:
* Make your ViewController a delegate for NRF8001Delegate and implement the delegate fns

### Test it
Fire up a serial terminal using the BLE Echo exmaple on your arduino. Send a string with a newline and you should receive it on the ios side. 

### Files
NRF8001 is a singleton class that manages the BLE lifecycle, writes to the module, and sends the following nsnotifications:
* NRFString : when a new string is received from the module(that ends in a newline)
* NRFStatus : connection / disconnection

NRF8001Delegate handles the notifications from NRF8001 object

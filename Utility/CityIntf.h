//
//  CityIntf.h
//  Weather
//
//  Created by nd on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>

@interface CityIntf : NSObject
<CLLocationManagerDelegate, MKReverseGeocoderDelegate>{
	CLLocationManager *locationManager; 
	MKReverseGeocoder *geoCoder;
	
	NSObject* class_func_owner; 
	SEL  class_func_responseData;
	
	BOOL stoped;

}

@property (nonatomic, retain) CLLocationManager *locationManager; 
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;

+ (CityIntf*) getInstance;
+ (void) free;

- (void) getCityName: (NSObject*)FParentClass responseMethod:(SEL)FResponseMethod;
- (void) stop;


extern CityIntf* g_searchCity;

@end

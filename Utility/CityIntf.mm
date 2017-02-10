//
//  CityIntf.m
//  Weather
//
//  Created by nd on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CityIntf.h"
#import <MapKit/MapKit.h> 
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <AddressBook/AddressBook.h>  
#import <Foundation/NSURLRequest.h>
#import "SBJSON.h"
#import "PubFunction.h"
#import "NetConstDefine.h"
#import "DBMng.h"

CityIntf* g_searchCity = nil;

@implementation CityIntf
@synthesize locationManager;
@synthesize geoCoder;

+ (CityIntf*) getInstance
{
	if (g_searchCity==nil)
	{
		g_searchCity = [[CityIntf alloc] init];
		g_searchCity.locationManager = nil;
		g_searchCity.geoCoder = nil;
	}
	
	return g_searchCity;
}

+ (void) free
{
	if (g_searchCity!=nil)
	{
	
		[g_searchCity release];
		g_searchCity = nil;
	}
}



- (void)dealloc 
{
	if (locationManager!=nil)
	{
		[locationManager stopUpdatingHeading];
		[locationManager setDelegate:nil];
		self.locationManager = nil;
	}
	
	if (geoCoder!=nil)
	{
		[geoCoder cancel];
		geoCoder.delegate = nil;
		self.geoCoder = nil;
	}
	
    [super dealloc];
}

- (void) stop
{	
	stoped = YES;
	
	if (locationManager!=nil)
		[locationManager  stopUpdatingLocation];
	
	if (geoCoder!=nil)
	{
		[geoCoder cancel];
		geoCoder.delegate = nil;
		self.geoCoder = nil;
	}
}

- (void) getCityName : (NSObject*) FParentClass 
	   responseMethod:(SEL) FResponseMethod
{	
	/*
	CLLocationCoordinate2D loc;
	loc.latitude = 26.08;
	loc.longitude = 119.28;
	
	self.geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:loc];
	[geoCoder release];
	geoCoder.delegate = self;
    [geoCoder start]; 
	*/
	
	[self stop];
	
	class_func_owner = FParentClass;
	class_func_responseData = FResponseMethod;

	if (locationManager==nil)
	{
		self.locationManager = [[CLLocationManager alloc] init];
		[locationManager release];
		locationManager.delegate = self;

	}

	stoped = NO;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy =kCLLocationAccuracyThreeKilometers;//3km 
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	/*

	if ([class_func_owner respondsToSelector:class_func_responseData]) 
		[class_func_owner performSelector:class_func_responseData withObject:nil];
	 */
	

	[locationManager  stopUpdatingLocation];
	if (stoped) return;
	
	//CLLocationCoordinate2D loc = newLocation.coordinate;
	self.geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	[geoCoder release];
	geoCoder.delegate = self;
    [geoCoder start]; 
}


- (void)locationManager:(CLLocationManager *)manager 
	   didFailWithError:(NSError *)error
{
	//LOG_ERROR(@"locationManager fail start");
	
	//[locationManager stopUpdatingLocation];
	
	
	/*
	CLLocationCoordinate2D loc;
	loc.latitude = 26.08;
	loc.longitude = 119.28;
	
	self.geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:loc];
	[geoCoder release];
	geoCoder.delegate = self;
    [geoCoder start]; 
	*/
	
	if (stoped) return;
	
	if ([class_func_owner respondsToSelector:class_func_responseData]) 
		[class_func_owner performSelector:class_func_responseData withObject:nil];
	 
	//locationManager.delegate = nil;
	//self.locationManager = nil;
	
	//LOG_ERROR(@"locationManager fail end");
}


// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder 
	   didFindPlacemark:(MKPlacemark *)placemark 
{
	//LOG_ERROR(@"reverseGeocoder ok start");

	if (stoped) return;
	
	TCityDataDetail* cityInfo = nil;
	if (placemark!=nil)
	{
		NSString* city = placemark.locality;
		NSString* prov = placemark.administrativeArea;
		NSArray * locList = nil;
		
		
		if (![PubFunction stringIsNullOrEmpty:city])
		{
			if ([city hasSuffix:@"市"] || [city hasSuffix:@"县"] || [city hasSuffix:@"镇"])
				city = [city substringToIndex:city.length-1];
			else if ([city hasSuffix:@"地区"])
				city = [city substringToIndex:city.length-2];
			
			locList = [AstroDBMng getCityDataByCityName:city];
		}
		
		if (locList!=nil && locList.count>0)
		{
			if (locList.count==1)
				cityInfo = [locList objectAtIndex:0];
			else 
			{
				for (TCityDataDetail* cdd in locList)
				{
					NSRange rg = [prov rangeOfString:cdd.datProv.sName];
					if (rg.location!=NSNotFound)
					{
						cityInfo = cdd;
						break;
					}
				}
			}
		}
		
	}
	
	if ([class_func_owner respondsToSelector:class_func_responseData]) 
		[class_func_owner performSelector:class_func_responseData withObject:cityInfo];
	
	//LOG_ERROR(@"reverseGeocoder ok end");
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	
	if (stoped) return;
	
	//LOG_ERROR(@"reverseGeocoder fail start");
	
	if ([class_func_owner respondsToSelector:class_func_responseData]) 
		[class_func_owner performSelector:class_func_responseData withObject:nil];
	
	//[geoCoder cancel];
	//self.geoCoder = nil;
	
	//LOG_ERROR(@"reverseGeocoder fail end");
}

@end

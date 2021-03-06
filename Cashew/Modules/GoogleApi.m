//
//  GoogleApi.m
//  Cashew
//
//  Created by Jonathan Chew on 9/14/14.
//  Copyright (c) 2014 JC. All rights reserved.
//

#import "GoogleApi.h"
#import <AFNetworking/AFNetworking.h>
#import "Config.h"

@implementation GoogleApi

+ (void)getGeocodeWithAddress:(NSString *)addressString forLocation:(NSString *)locationType withBlock: (successBlockWithResponse)successBlock
{
    NSDictionary *parameters = @{@"address": addressString};
    [self getGeocode: parameters withBlock: successBlock];
}

+ (void)getAddressWithGeocode:(CLLocation *)currentLocation forLocation:(NSString *)locationType withBlock: (successBlockWithResponse)successBlock
{
    NSDictionary *parameters = @{@"latlng": [NSString stringWithFormat:@"%f,%f",
                                             currentLocation.coordinate.latitude,
                                             currentLocation.coordinate.longitude]};
    [self getGeocode: parameters withBlock: successBlock];
}

+ (void)getGeocode:(NSDictionary *)parameters withBlock: (successBlockWithResponse) successBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *geocodeApiRootUrl = [[Config sharedConfig].apiURLs objectForKey:@"geocodeApiRootUrl"];
    
    [manager GET:geocodeApiRootUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)getGoogleDirections:(NSDictionary *)originGeocode toDestination:(NSDictionary *)destinationGeocode byMode:(NSString *)travelMode withBlock:(successBlockWithResponse)successBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *originCoordinates = [NSString stringWithFormat:@"%@,%@",
                                   [originGeocode objectForKey:@"lat"],[originGeocode objectForKey:@"lng"]];
    NSString *destinationCoordinates = [NSString stringWithFormat:@"%@,%@",
                                        [destinationGeocode objectForKey:@"lat"],[destinationGeocode objectForKey:@"lng"]];
    
    // Add two minutes to current time as 'current' departure time
    NSString *departureTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSDictionary *parameters = @{@"origin": originCoordinates,
                                 @"destination": destinationCoordinates,
                                 @"departure_time": departureTime,
                                 @"mode": travelMode};
    
    NSString *googleDirectionsApiRootUrl = [[Config sharedConfig].apiURLs objectForKey:@"googleDirectionsApiRootUrl"];
    
    [manager GET:googleDirectionsApiRootUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end

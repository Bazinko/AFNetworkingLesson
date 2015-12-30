//
//  PLCGoogleMapService.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCGoogleMapService.h"
#import <AFNetworking.h>
#import "PLCLocationHelper.h"
#import "PLCPlaceMapper.h"

NSString *const PLCGoogleBaseURL = @"https://maps.googleapis.com/maps/api/place/";
NSString *const PLCGoogleAPIKey = @"AIzaSyBhpEhL8vvERVuY9ynrHuElB7kEKdWyiHI";
static PLCGoogleMapService *sharedInstance = nil;

@interface PLCGoogleMapService()

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@end


@implementation PLCGoogleMapService

+ (PLCGoogleMapService*)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[PLCGoogleMapService alloc] init];
        }
        return sharedInstance;
    }
}

+ (void)resetSharedInstance {
    @synchronized(self) {
        sharedInstance = nil;
    }
}

-(NSString*)getAPIkey{
    return PLCGoogleAPIKey;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:PLCGoogleBaseURL];
        _requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void)getPlacesBySearchingWithText:(NSString *)text
                             success:(PLCSuccessBlock)successBlock
                             failure:(PLCFailureBlock)failure {
    NSDictionary *params = @{
                             @"key": PLCGoogleAPIKey,
                             @"query": text,
                             @"radius": @(1000)
                             };
    
    void(^success)(NSURLSessionTask *, id) =
    ^(NSURLSessionTask * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *placesModels = [NSMutableArray new];
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray *results = responseObject[@"results"];
            if (results.count == 0) {
                if (successBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successBlock(@[]);
                    });
                }
            }
            for (NSDictionary *placeDict in results) {
                [placesModels addObject:[PLCPlaceMapper placeWithDictionary:placeDict]];
            }
            if (successBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock([placesModels copy]);
                });
            }
        } else {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *errorMessage = responseObject[@"error_message"];
                    NSDictionary *dict = @{@"localizedDescription": errorMessage};
                    NSError *error = [NSError errorWithDomain:@"PLCErrorDomain" code:-1 userInfo:dict];
                    failure(error);
                });
                
            }
        }
        
    };
    
    void(^fail)(id, NSError *) = ^(NSURLSessionTask * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_requestManager GET:@"https://maps.googleapis.com/maps/api/place/textsearch/json" parameters:params progress:nil success:success failure:fail];
    });
}

- (void)getPlacesNearCoordinate:(CLLocationCoordinate2D)location
                        success:(PLCSuccessBlock)successBlock
                        failure:(PLCFailureBlock)failure {
    
    NSDictionary *params = @{
                             @"key": PLCGoogleAPIKey,
                             @"location": stringFromCoordinate(location),
                             @"radius": @(1000)
                             };
    
    void(^success)(NSURLSessionTask *, id) =
    ^(NSURLSessionTask * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *placesModels = [NSMutableArray new];
        
        NSArray *results = responseObject[@"results"];
        if (results.count == 0) {
            if (successBlock) {
                successBlock(@[]);
            }
        }
        for (NSDictionary *placeDict in results) {
            [placesModels addObject:[PLCPlaceMapper placeWithDictionary:placeDict]];
        }
        if (successBlock) {
            successBlock([placesModels copy]);
        }
        
    };
    
    void(^fail)(id, NSError *) = ^(NSURLSessionTask * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"ERROR:%@", error);
    };
    
    [_requestManager GET:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json" parameters:params progress:nil success:success failure:fail];
}

@end
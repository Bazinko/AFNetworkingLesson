//
//  PLCGoogleMapService.h
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^PLCSuccessBlock)(id);
typedef void(^PLCFailureBlock)(NSError *);

@interface PLCGoogleMapService : NSObject

- (void)getPlacesBySearchingWithText:(NSString *)text
                             success:(PLCSuccessBlock)successBlock
                             failure:(PLCFailureBlock)failure;

- (void)getPlaceImageWithReference:(NSString *)reference
                           success:(PLCSuccessBlock)successBlock
                           failure:(PLCFailureBlock)failure;


@end

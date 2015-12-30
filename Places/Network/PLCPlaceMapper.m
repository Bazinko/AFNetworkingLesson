//
//  PLCPlaceMapper.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCPlaceMapper.h"
#import "PLCPlace.h"
#import "PLCGoogleMapService.h"

@implementation PLCPlaceMapper

+ (PLCPlace *)placeWithDictionary:(NSDictionary *)dictionary
{
    PLCPlace *result = [PLCPlace new];
    NSString *name = dictionary[@"name"] ? : @"";
    
    result.name = name;
    NSArray *photos = dictionary[@"photos"];
    
    if (photos.count == 0) {
        result.imageURL = nil;
        return result;
    }
    
    NSDictionary *photo = photos.firstObject;
    NSString *imgUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxheight=88&photoreference=%@&key=%@",photo[@"photo_reference"],[PLCGoogleMapService sharedInstance].getAPIkey];
    
    result.imageURL = imgUrl;
    

    return result;
}

@end

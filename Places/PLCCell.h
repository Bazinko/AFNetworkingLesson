//
//  PLCCell.h
//  Places
//
//  Created by Евгений Сергеев on 07.12.15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLCPlace.h"

@interface PLCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImage;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
- (void)updateCellWithModel:(PLCPlace *)model;
@end

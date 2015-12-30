//
//  PLCCell.m
//  Places
//
//  Created by Евгений Сергеев on 07.12.15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCCell.h"
#import "PLCGoogleMapService.h"
#import <UIImageView+AFNetworking.h>

@implementation PLCCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithModel:(PLCPlace *)model{
    [_placeNameLabel setText:[model name]];
    if (!model.imageURL) {
        return;
    }
    __weak UIImageView *weakImageView = self.placeImage;
    NSURL *url = [NSURL URLWithString:model.imageURL];
    [_placeImage setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        [weakImageView setImage:image];
    }
                             failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 NSLog(@"ERROR downloading img: %@",[error localizedDescription]);
                             }];
}


@end

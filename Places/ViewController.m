//
//  ViewController.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "ViewController.h"
#import "PLCGoogleMapService.h"
#import "PLCPlace.h"
#import "PLCCell.h"
#import <MBProgressHUD.h>

@interface ViewController () <UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) PLCGoogleMapService *mapService;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.mapService = [[PLCGoogleMapService alloc] init];
}

- (void)showAlertView:(NSString *)text {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error!" message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    self.items = nil;
    [self.tableView reloadData];
    [self loadPlacesWithText:searchBar.text];
}

- (void)loadPlacesWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    [self.mapService getPlacesBySearchingWithText:text success:^(NSArray *result) {
        [hud hide:YES];
        self.items = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [self showAlertView:error.localizedDescription];
    }];
}

- (void)loadImageForPlace:(PLCPlace *)place {
    if (place.imageURL) {
        [self.mapService getPlaceImageWithReference:place.imageURL success:^(UIImage *image) {
            place.image = image;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self showAlertView:error.localizedDescription];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLCCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PLCPlace *place = self.items[indexPath.row];
    cell.placeNameLabel.text = place.name;
    
    if (!place.image) {
        [self loadImageForPlace:place];
    } else {
        cell.placeImage.image = place.image;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}


@end

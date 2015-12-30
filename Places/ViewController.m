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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) PLCGoogleMapService *mapService;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.tableView.estimatedRowHeight = 88.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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

-(void)fetchResultsWithString:(NSString*)str{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [[PLCGoogleMapService sharedInstance] getPlacesBySearchingWithText:str success:^(NSArray *arr) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        _items = arr;
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController
                           animated:YES completion:nil];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLCCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PLCPlace *model = [self.items objectAtIndex:indexPath.row];
    
    [cell updateCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}


@end

//
//  MovieTableViewController.m
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//
#import <UIImageView+AFNetworking.h>

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "MovieRequester.h"

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self searchMoviesUsingText:@"hobbit"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.movies count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieTableViewCell";
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    
    [cell.posterImageView setImageWithURL:[NSURL URLWithString:movie.posterUrl]];
    cell.titleLabel.text = movie.title;
    cell.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)movie.year];
    cell.ratingLabel.text = [NSString stringWithFormat:@"★%@", movie.rating];
    
    return cell;
}

#pragma  mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchMoviesUsingText:searchBar.text];
}

- (void)searchMoviesUsingText:(NSString *)searchText
{
    if ([searchText length] > 0) {
        /* show spinning indicator */
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[MovieRequester sharedRequester] searchMoviesWithText:searchText
                                                    completion:^(BOOL success, NSArray *result) {
                                                        if (success) {
                                                            [self.movieSearchBar resignFirstResponder];
                                                            
                                                            self.movies = result;
                                                            [self.tableView reloadData];
                                                            
                                                            [self.navigationController.navigationBar.topItem setTitle:searchText];
                                                            
                                                            [hud hide:YES];
                                                        } else {
                                                            /* error handling */
                                                            Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
                                                            reachability.reachableBlock = ^(Reachability *reachability) {
                                                                hud.mode = MBProgressHUDModeText;
                                                                hud.labelText = @"No Result";
                                                                double delayInSeconds = 1.0;
                                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                    [hud hide:YES];
                                                                });
                                                            };
                                                            reachability.unreachableBlock = ^(Reachability *reachability) {
                                                                hud.mode = MBProgressHUDModeText;
                                                                hud.labelText = @"Network Unavailable";
                                                                double delayInSeconds = 1.0;
                                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                    [hud hide:YES];
                                                                });
                                                            };
                                                            [reachability startNotifier];
                                                        }
                                                    }];
    }
}

@end

//
//  MovieRequester.m
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//

#import "MovieRequester.h"

#define MOVIES_IO_API_SEARCH_URL @"http://api.movies.io/movies/search?q=%@"

@implementation MovieRequester

static MovieRequester *instance = nil;
+ (instancetype)sharedRequester {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[MovieRequester alloc] init];
    });
    
    return instance;
}

- (void)searchMoviesWithText:(NSString *)text completion:(void(^)(BOOL success, NSArray *result))block
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:MOVIES_IO_API_SEARCH_URL, text]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:0
                                                            error:&error];
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        for (NSDictionary *movieData in [data objectForKey:@"movies"]) {
            Movie *movie = [Movie movieWithJsonData:movieData];
            [movies addObject:movie];
        }
        
        /* sort by year descending */
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
        [movies sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        if (error == nil) {
            block(YES, movies);
        } else {
            block(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO, nil);
    }];
    [operation start];
}

@end

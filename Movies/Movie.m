//
//  Movie.m
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+ (instancetype)movieWithJsonData:(NSDictionary *)jsonData
{
    Movie *movie = [[self alloc] init];
    movie.title = [jsonData objectForKey:@"title"];
    movie.year = [[jsonData objectForKey:@"year"] integerValue];
    movie.rating = [jsonData objectForKey:@"rating"];
    movie.posterUrl = [[[jsonData objectForKey:@"poster"] objectForKey:@"urls"] objectForKey:@"w92"];
    movie.trailerUrl = [[jsonData objectForKey:@"trailer"] objectForKey:@"url"];
    
    return movie;
}

@end

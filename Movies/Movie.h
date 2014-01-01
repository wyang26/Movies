//
//  Movie.h
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *posterUrl;
@property (nonatomic, copy) NSString *trailerUrl;

+ (instancetype)movieWithJsonData:(NSDictionary *)jsonData;

@end

//
//  MovieRequester.h
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieRequester : NSObject

+ (instancetype)sharedRequester;

- (void)searchMoviesWithText:(NSString *)text completion:(void(^)(BOOL success, NSArray *result))block;

@end

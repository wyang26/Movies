//
//  MovieTableViewCell.m
//  Movies
//
//  Created by William on 2013/12/29.
//  Copyright (c) 2013年 William. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

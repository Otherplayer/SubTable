//
//  DataSource.h
//  TestTableView
//
//  Created by __无邪_ on 15/2/2.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataInfo : NSObject

@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, unsafe_unretained) BOOL isOpened;
@property (nonatomic, strong)NSString *identifier;
@end

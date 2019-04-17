//
//  Man.h
//  Block
//
//  Created by xiekunpeng on 2019/4/17.
//  Copyright © 2019 xboker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger (^IntBlock)(NSInteger num);

NS_ASSUME_NONNULL_BEGIN

@interface Man : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy)   IntBlock       intBlock;




@end

NS_ASSUME_NONNULL_END

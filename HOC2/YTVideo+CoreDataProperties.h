//
//  YTVideo+CoreDataProperties.h
//  HOC2
//
//  Created by Markim Shaw on 5/14/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "YTVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTVideo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *videoId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *thumbnail;

@end

NS_ASSUME_NONNULL_END

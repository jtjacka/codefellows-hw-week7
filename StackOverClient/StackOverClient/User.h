//
//  User.h
//  
//
//  Created by Jeffrey Jacka on 9/16/15.
//
//

#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSNumber* age;
@property (strong, nonatomic) NSNumber* reputation;
@property (strong, nonatomic) NSString *website;

@end

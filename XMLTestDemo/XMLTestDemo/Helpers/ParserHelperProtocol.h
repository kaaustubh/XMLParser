//
//
//
//  Protocol which every parser needs to confirm to.
//
//  Created by Kaustubh Deshpande 17.06.2015
//  Copyright (c) 2015 Volkswagen AG. All rights reserved.
//
//


#import <Foundation/Foundation.h>


typedef enum
{
    ParserTypeJSON,
    ParserTypeXML
}ParserType;

@protocol ParserHelperProtocol <NSObject>

@required

/**
 Parses xml file into NSDictionry
 @param raw NSData which needs to be parsed
 @param errorObject which needs to be passed if there is some error in parsing.
 @return BOOL value depending on the parser success
 */
//-(BOOL) parseData:(NSData *)data parseError:(NSError **)parseError;

-(void) parseData:(NSData *)data completionBlock:(void(^)(id returnDictionary, NSError *error))completionBlock;

/**
  Sets the dictionary when the parsing is successfuly done.
 */
@property (strong, nonatomic) NSMutableDictionary *returnDictionary;


@end

//
//
//
//
//  XML parser which parses NSData into NSDictionary
//
//  Created by Kaustubh Deshpande 17.06.2015
//  Copyright (c) 2015 Volkswagen AG. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ParserHelperProtocol.h"

@interface XMLParser : NSObject <NSXMLParserDelegate, ParserHelperProtocol>
{
    
}

@property (strong, nonatomic) id returnDictionary;

@end

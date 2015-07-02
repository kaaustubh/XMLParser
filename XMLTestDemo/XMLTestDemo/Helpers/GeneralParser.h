
//
//  A generic parser which returns parser depending on the type we pass eg XML or JSON
//  Created by Kaustubh Deshpande 17.06.2015
//  Copyright (c) 2015 Volkswagen AG. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ParserHelperProtocol.h"

@interface GeneralParser : NSObject

+(id<ParserHelperProtocol>)getParserOfType:(ParserType) type;

@end

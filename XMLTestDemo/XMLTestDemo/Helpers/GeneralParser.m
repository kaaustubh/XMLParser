
#import "GeneralParser.h"
#import "XMLParser.h"


@implementation GeneralParser


+(id<ParserHelperProtocol>)getParserOfType:(ParserType) type
{
    id<ParserHelperProtocol>parser;
    switch (type) {
        case ParserTypeXML:
            parser=[[XMLParser alloc] init];
            break;
            
        default:
            break;
    }
    return parser;
}

@end

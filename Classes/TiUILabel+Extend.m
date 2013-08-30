/**
 * Module developed by Napp
 * Author Mads Møller
 * www.napp.dk
 *
 * TiUILabel+Extend by @dezinezync
 * Author: Nikhil Nigade
 * dezinezync.com
 */

#import "TiUILabel+Extend.h"
#import "TiUtils.h"

@implementation TiUILabel (Extend)

-(void)setAttributedText_:(id)args
{
    //Check if attributedText is supported. (iOS6 +)
    if (![[self label] respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    
    NSString *text = [TiUtils stringValue:[args objectForKey:@"text"]];
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSArray *attributes = [args objectForKey:@"attributes"];
    
    for(id object in attributes) {
        
        NSString *str = [TiUtils stringValue:[object valueForKey:@"text"]];
        NSRange range = [text rangeOfString:str options:(NSCaseInsensitiveSearch)];
        
        NSMutableDictionary *_attr = [[NSMutableDictionary alloc] init];
        
        //FONT
        if([object valueForKey:@"font"] != nil) {
            [_attr setObject:[[TiUtils fontValue:[object valueForKey:@"font"]] font] forKey:NSFontAttributeName];
        }
        
        //COLOR
        if([object valueForKey:@"color"] != nil) {
            
            UIColor *textColor = [[TiUtils colorValue:[object valueForKey:@"color"]] _color];
            
            [_attr setObject:(textColor !=nil)?textColor:[UIColor darkTextColor] forKey:NSForegroundColorAttributeName];
        }
        
        //UNDERLINE
        if([object valueForKey:@"underline"] != nil) {
            int *uls = [[object valueForKey:@"underline"] integerValue];
            
            if(uls != NULL) {
                [_attr setObject:[NSNumber numberWithInt:uls] forKey:NSUnderlineStyleAttributeName];
            }
            
        }
        
        //BACKGROUND
        if([object valueForKey:@"backgroundColor"] != nil) {
            
            UIColor *bgColor = [[TiUtils colorValue:[object valueForKey:@"backgroundColor"]] _color];
            
            [_attr setObject:(bgColor !=nil)?bgColor:[UIColor lightGrayColor] forKey:NSBackgroundColorAttributeName];
            
        }
        
        //SHADOW : Non-working implementation
        /*if([object valueForKey:@"shadow"] != nil) {
            
            NSDictionary *shadowObject = [object valueForKey:@"shadow"];
            
            NSShadow *shadow = [[NSShadow alloc] init];
            
            //Shadow Color
            UIColor *shadowColor = [[TiUtils colorValue:[shadowObject objectForKey:@"shadowColor"]] _color];
            [shadow setShadowColor:(shadowColor != nil)?shadowColor:[UIColor blackColor]];
            
            //Shadow Offset
            
            if([shadowObject objectForKey:@"shadowOffset"] != nil) {
                CGPoint p = [TiUtils pointValue:[shadowObject objectForKey:@"shadowOffset"]];
                CGSize shadowOffset = {p.x,p.y};
                [shadow setShadowOffset:shadowOffset];
            }
            else {
                CGSize shadowOffset = {0.0,0.0};
                [shadow setShadowOffset:shadowOffset];
            }
            
            //Shadow Blur Radius
            if([object valueForKey:@"shadowRadius"] != nil) {
                CGFloat shadowRadius = [[object valueForKey:@"shadowRadius"] floatValue];
                [shadow setShadowBlurRadius:shadowRadius];
            }
            else {
                CGFloat shadowRadius = 1.0;
                [shadow setShadowBlurRadius:shadowRadius];
            }
            
            [_attr setObject:shadow forKey:NSShadowAttributeName];
            
        }*/
        
        //Setting it all up
        [attrS setAttributes:_attr range:range];
        
        [_attr release];
        [str release];
        
    }
    
    //Set the text. Notify the proxy about contentChange
    [[self label] setAttributedText:attrS];
    [(TiViewProxy *)[self proxy] contentsWillChange];
}

@end
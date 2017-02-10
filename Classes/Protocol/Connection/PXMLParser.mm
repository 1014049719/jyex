//
//  PXMLParser.m
//  pass91
//
//  Created by Zhaolin He on 09-8-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PXMLParser.h"
#import "tinyxml.h"

@implementation PXMLParser

+(BOOL) parseXMLWithURL:(NSURL *)url returnValue:(NSDictionary **)retValue{
	NSString *statusCode=nil;
	NSData *rs_data=[NSData dataWithContentsOfURL:url];
	NSString *result=[[[NSString alloc] initWithData:rs_data encoding:NSUTF8StringEncoding] autorelease];
	if(result!=nil){
		TiXmlDocument myDocument;
		TiXmlElement *rootElement;
		myDocument.Parse([result UTF8String]);
		rootElement=myDocument.RootElement();
		if(rootElement==NULL)return NO;
		
		TiXmlElement *statusCode_node;
		if(rootElement->FirstChildElement()!=NULL)
			statusCode_node=rootElement->FirstChildElement()->FirstChildElement();
		if(statusCode_node!=NULL){
			if(statusCode_node->GetText()!=NULL){
				statusCode=[NSString stringWithUTF8String:statusCode_node->GetText()];
				MLOG(@"code:%@",statusCode);
			}
		}
		
		if([statusCode isEqualToString:@"0"]){
			TiXmlElement *items;
			if(rootElement->FirstChildElement()!=NULL&&rootElement->FirstChildElement()->NextSiblingElement()!=NULL)
				items=rootElement->FirstChildElement()->NextSiblingElement()->FirstChildElement();
			if(items!=NULL){
				TiXmlElement *child =items->FirstChildElement();
				NSMutableDictionary *info=[NSMutableDictionary dictionary];
				if(child!=NULL){
					do{
						if(child->GetText()!=NULL){
							[info setObject:[NSString stringWithUTF8String:child->GetText()] forKey:[NSString stringWithUTF8String:child->Value()]];
						}
					}while(child=child->NextSiblingElement());
					*retValue=info;
					return YES;
				}
			}//init dic info
		}else{
			NSString *description=nil,*error=nil;
			TiXmlElement *desc_node;
			TiXmlElement *err_node;
			
			if(statusCode_node!=NULL)
				desc_node=statusCode_node->NextSiblingElement();
			if(desc_node!=NULL&&desc_node->NextSiblingElement()!=NULL)
				err_node=desc_node->NextSiblingElement()->FirstChildElement();
			
			if(desc_node!=NULL){
				if(desc_node->GetText()!=NULL){
					description=[NSString stringWithUTF8String:desc_node->GetText()];
					MLOG(description);
				}
			}
			if(err_node!=NULL){
				if(err_node->GetText()!=NULL){
					error=[NSString stringWithUTF8String:err_node->GetText()];
					MLOG(error);
				}
			}
			if(description!=nil&&error!=nil){
				NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:description,@"description",error,@"error",nil];
				*retValue=info;
				return NO;
			}
		}//statusCode==0
	}//result !=nil
	return NO;
}
@end

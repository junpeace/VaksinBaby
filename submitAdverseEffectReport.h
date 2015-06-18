//
//  submitAdverseEffectReport.h
//  myVac4Baby
//
//  Created by Jun on 14/11/6.
//  Copyright (c) 2014年 jun. All rights reserved.
//

#import "JsonRequest.h"
#import "bizAdverseReport.h"

@interface submitAdverseEffectReport : JsonRequest

-(id)init_submitAdverseEffectReport :(bizAdverseReport*) report;

@end

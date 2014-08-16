//
//  EnumHeader.h
//  AnyGo
//
//  Created by tony on 8/12/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#ifndef AnyGo_EnumHeader_h
#define AnyGo_EnumHeader_h
/**
 *  性别
 */
typedef NS_ENUM(NSInteger, Gender) {
    /**
     *  女性
     */
    GenderFemale = 0,
    /**
     *  男性
     */
    GenderMale,
    
    GenderOther
};

typedef NS_ENUM(NSInteger, AddressType) {
    AddressTypeStart = 0,
    AddressTypeEnd
};

#endif

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

/**
 *  关系
 */
typedef NS_ENUM(NSInteger, RelationType) {
    /**
     *  没有任何关系
     */
    RelationTypeNone = 1,
    /**
     *  关注
     */
    RelationTypeFollowing,
    /**
     *  被关注
     */
    RelationTypeFollowed,
    /**
     *  互相关注
     */
    RelationTypeBothWayFollowed,
    /**
     *  拉黑
     */
    RelationTypeBlock,
    /**
     *  被拉黑
     */
    RelationTypeBlocked
};

#endif

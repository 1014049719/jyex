/*
 *  BussDataTypeDef.h
 *  Astro
 *
 *  Created by root on 11-11-18.
 *  Copyright 2011 ND SOFT. All rights reserved.
 *
 */

#ifndef _BussDataTypeDef_H_20111118_
#define _BussDataTypeDef_H_20111118_

#pragma mark -
#pragma mark 枚举类型


////////////////////////////////////////////////////////////////
//                       共通部分
////////////////////////////////////////////////////////////////
#define  INVALID_TYPE   -1
#define  PEP_INFO_TYPE  0
#define  PEP_BIRTH_INFO_TYPE  1
#define  PEP_INFO_LIST_TYPE  2
#define  PEP_NAME_TYPE  3
#define  DATE_INFO_TYPE 4
#define  DATE_INFO_LIST_TYPE 5

////////////////////////////////////////////////////////////////
//                       紫微部分
////////////////////////////////////////////////////////////////
#define  PEP_ZIWEI_PLATE_TYPE 1000

// 我的十二宫解释
#define  PEP_12G_RESULT_TYPE            1001
// 命宫主星信息
#define  PEP_MGZX_INFO_TYPE             1002
// 命宫主星信息和解释
#define  PEP_MGZX_IFNORESULT_TYPE       1003

// 紫微大限列表
#define  PEP_ZWDAXIAN_TIMELIST_TYPE     1004
// 紫微大限参数
#define  PEP_ZWDAXIAN_PARAM_TYPE        1005
// 紫微流年参数
#define  PEP_ZWLIUNIAN_PARAM_TYPE       1006
// 紫微流月参数
#define  PEP_ZWLIUYUE_PARAM_TYPE        1007
// 紫微流日参数
#define  PEP_ZWLIURI_PARAM_TYPE         1008
// 紫微格局解释
#define  PEP_ZWPATTERN_RESULT_TYPE      1009
// 紫微宫位解释参数
#define  PEP_ZWPALACE_PARAM_TYPE        1010
// 紫微宫位解释
#define  PEP_ZWPALACE_RESULT_TYPE       1011
// 紫微运势解释类型
#define  PEP_ZWLUCK_RESUTL_TYPE         1012
// 紫微爱情解释类型
#define  PEP_ZWLOVE_RESUTL_TYPE         1013
// 紫微爱情婚姻指南类型
#define  PEP_ZWLOVE_COMPASS_RESUTL_TYPE    1014
// 紫微爱情合婚密断类型
#define  PEP_ZWLOVE_HHMD_RESUTL_TYPE     1015

// 命宫主星信息列表
#define  PEP_MGZX_INFO_LIST_TYPE         1016


////////////////////////////////////////////////////////////////
//                       八字部分
////////////////////////////////////////////////////////////////
#define  PEP_BAZI_NOR_PLATE_TYPE						 4000

#define  PEP_BAZI_PRO_PLATE_TYPE						 4001

#define  PEP_BAZI_DUAN_YU_PLATE_TYPE					 4002

// 八字婚姻恋爱红皮书
#define PEP_BAZI_GET_HPS_PLATE_TYPE						 4003
// 八字恋爱观
#define PEP_BAZI_GET_LAG_PLATE_TYPE						 4004
// 八字夫妻宫十神
#define PEP_BAZI_GET_FQGSS_PLATE_TYPE					 4005
// 八字感情运势
#define PEP_BAZI_GET_GQYS_PLATE_TYPE					 4006
// 八字结婚时间点
#define PEP_BAZI_GET_JHSJD_PLATE_TYPE					 4007
// 八字最佳配偶信息
#define PEP_BAZI_GET_ZJPOXX_PLATE_TYPE					 4008
// 八字合婚
#define PEP_BAZI_GET_BZHH_PLATE_TYPE					 4009

// 八字运势参数
#define PEP_BAZI_GET_YUNSHI_PARAM_TYPE					 4010
// 八字运势结果
#define PEP_BAZI_GET_YUNSHI_RESULT_TYPE					 4011

#define	PEP_BAZI_GET_BZNAVI_PLATE_TYPE					 4012

////////////////////////////////////////////////////////////////
//                       姓名部分
////////////////////////////////////////////////////////////////
#define  PEP_NAME_PLATE_TYPE   8000
#define  PEP_NAME_RESULT_TYPE  8001

////////////////////////////////////////////////////////////////
//                       星座部分
////////////////////////////////////////////////////////////////
#define  PEP_CONS_NORMAL_RESULT_TYPE                     9000
#define  PEP_CONS_BLOOD_RESULT_TYPE                      9001
#define  PEP_CONS_MATCH_RESULT_TYPE                      9002
#define  PEP_CONS_DATE_INFO_TYPE                         9003
#define  PEP_CONS_MATCH_DATE_INFO_TYPE                   9004
#define  PEP_CONS_BLOOD_DATE_INFO_TYPE                   9005
#define  PEP_CONS_CONS_IDX_TYPE                          9006
#define  PEP_CONS_MATCH_CONS_IDX_TYPE                    9007
#define  PEP_CONS_BLOOD_CONS_IDX_TYPE                    9008
#define  PEP_CONS_ABLOOD_RESULT_TYPE                     9009

////////////////////////////////////////////////////////////////
//                       民俗预测
////////////////////////////////////////////////////////////////
#define  PEP_CUSTOM_CYJ_RESULT_TYPE                      10000
#define  PEP_CUSTOM_EDADVICE_RESULT_TYPE                 10001
#define  PEP_CUSTOM_ZXJR_PARAM_TYPE                      10002
#define  PEP_CUSTOM_TELEPHOEN_PARAM_TYPE                 10003
#define  PEP_CUSTOM_TELEPHOEN_RESULE_TYPE                10004
#define  PEP_CUSTOM_ZHONGONG_PARAM_TYPE                  10005
#define  PEP_CUSTOM_ZHONGONG_RESULE_TYPE                 10006 
#define  PEP_CUSTOM_XINZUO_PARAM_TYPE                    10005
#define  PEP_CUSTOM_XINZUO_RESULE_TYPE                   10006 
#define  PEP_CUSTOM_TDYGOODTIME_RESULT_TYPE		    	 10007
#define  PEP_CUSTOM_SXYUNSHI_PARAM_TYPE			    	 10008
#define  PEP_CUSTOM_SXYUNSHI_RESULT_TYPE				 10009
#define  PEP_CUSTOM_XZYUNSHI_PARAM_TYPE					 10010
#define  PEP_CUSTOM_XZYUNSHI_RESULT_TYPE				 10011
#define  PEP_CUSTOM_XZCURMONTH_RESULT_TYPE				 10012
//输入黄道吉日关键字，得出相应的小标题原文
#define  PEP_ZMTCUSTOM_DETORGNAME_RESULT_TYPE			 10013
//黄道吉日查询常用词汇
#define  PEP_ZMTCUSTOM_COMUSENAME_RESULT_TYPE			 10014

////////////////////////////////////////////////////////////////
//                       大众版部分
////////////////////////////////////////////////////////////////
#define  PEP_BZZWYUNSH_RESULT_TYPE						 11000
#define  PEP_NATURE_ANALYSE_RESULT_TYPE					 11001
#define  PEP_LOVE_TAO_HUA_RESULT_TYPE					 11002
#define  PEP_LOVE_HE_HUN_RESULT_TYPE					 11003
#define  PEP_YUNSH_RESULT_TYPE                           11004
#define  PEP_SHIYE_RESULT_TYPE                           11005
#define  PEP_NAMEPD_RESULT_TYPE                          11006
#define  PEP_CAIFU_RESULT_TYPE                           11007

////////////////////////////////////////////////////////////////
//                       专业版部分
////////////////////////////////////////////////////////////////
#define  PEP_PRO_BZ_RESULT_TYPE							 12000
#define  PEP_PRO_MS_RESULT_TYPE							 12001

////////////////////////////////////////////////////////////////
//                       事件反推部分
////////////////////////////////////////////////////////////////
#define  PEP_FT_PARAM_TYPE								 13000
#define  PEP_FT_RESULT_TYPE								 13001
#define  PEP_FT_ANSWER_TYPE								 13002

////////////////////////////////////////////////////////////////
//                       交易管理部分
////////////////////////////////////////////////////////////////
#define  PEP_TRADE_MGR_RESULT_TYPE						 14000

////////////////////////////////////////////////////////////////
//                       梅花六爻风水奇门排盘部分
////////////////////////////////////////////////////////////////
#define  PEP_YCPP_MH_PARAM_TYPE							 15000
#define  PEP_YCPP_MH_RESULT_TYPE						 15001
#define  PEP_YCPP_LY_PARAM_TYPE							 15002
#define  PEP_YCPP_LY_RESULT_TYPE						 15003
#define  PEP_YCPP_FS_PARAM_TYPE							 15004
#define  PEP_YCPP_FS_RESULT_TYPE						 15005
#define  PEP_YCPP_QM_PARAM_TYPE							 15006
#define  PEP_YCPP_QM_RESULT_TYPE						 15007

////////////////////////////////////////////////////////////////
//                       好友挖掘部分
////////////////////////////////////////////////////////////////
#define  PEP_FR_FRIEND_INFO_TYPE						 16000
#define  PEP_FR_FRIEND_MLINFO_TYPE						 16001
#define  PEP_FR_SAVEPEOPLE_PARAM_TYPE					 16002
#define  PEP_FR_SAVEPEOPLE_RESULT_TYPE					 16003
#define  PEP_FR_GETPEOPLE_PARAM_TYPE					 16004
#define  PEP_FR_GETPEOPLE_RESULT_TYPE					 16005
#define  PEP_FR_SEARFRIEND_PARAM_TYPE					 16006
#define  PEP_FR_SEARFRIEND_RESULT_TYPE					 16007
#define  PEP_FR_GETPD_PARAM_TYPE						 16008
#define  PEP_FR_GETPD_RESULT_TYPE						 16009

////////////////////////////////////////////////////////////////
//                       大众版星座部分
////////////////////////////////////////////////////////////////
#define  PEP_XZ_XZDSPP_JWD_TYPE						     18000
#define  PEP_XZ_XZDSPP_ASTROWZ_TYPE					     18001
#define  PEP_XZ_XZDSPP_SEFNUM_TYPE					     18002
#define  PEP_XZ_XZDSPP_SEWZ_TYPE					     18003
#define  PEP_XZ_XZDSPP_XW_TYPE						     18004
#define  PEP_XZ_XZDSPP_PARAM_TYPE					     18005
#define  PEP_XZ_XZDSPP_RESULT_TYPE					     18006
//行星在12星座
#define  PEP_XZ_XZDS_XXXZ_TYPE							 18007
//行星在12宫位
#define  PEP_XZ_XZDS_XXGW_TYPE							 18008
//行星相位分析
#define  PEP_XZ_XZDS_XXXW_TYPE							 18009
//宫位在12星座
#define  PEP_XZ_XZDS_GWXZ_TYPE							 18009

// 星座运势 [Add By 陈希, 2011.2.12]
//
#define  PEP_XZ_XZDS_ASTRO_FORTUNE_PARAM_TYPE			 18010	// 星座运势下载参数
#define  PEP_XZ_XZDS_ASTRO_FORTUNE_DAY_TYPE				 18011	// 星座日运势
#define  PEP_XZ_XZDS_ASTRO_FORTUNE_WEEK_TYPE			 18012	// 星座周运势
#define  PEP_XZ_XZDS_ASTRO_FORTUNE_MONTH_TYPE			 18013	// 星座月运势
#define  PEP_XZ_XZDS_ASTRO_FORTUNE_YEAR_TYPE			 18014	// 星座年运势

////////////////////////////////////////////////////////////////
//                       大众版积分消费
////////////////////////////////////////////////////////////////
#define  PEP_DZ_CONSUME_ALL_TYPE						 42004
#define  PEP_DZ_CONSUME_CAREER_TYPE						 42005
#define  PEP_DZ_CONSUME_HEALTH_TYPE						 42006
#define  PEP_DZ_CONSUME_LOVE_TYPE						 42007
#define  PEP_DZ_CONSUME_FATE_TYPE						 42008
#define  PEP_DZ_CONSUME_NAMEPD_TYPE						 42009
#define  PEP_DZ_CONSUME_FATE_YEAR						 45010
#define  PEP_DZ_CONSUME_FATE_MONTH_DAY					 45011

////////////////////////////////////////////////////////////////
//                       专业版消费积分
////////////////////////////////////////////////////////////////
#define  PEP_PRO_CONSUME_FATE_YEAR						 40012
#define  PEP_PRO_CONSUME_FATE_MONTH_DAY					 40013

#endif

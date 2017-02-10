/************************************************************************************
 * 
 *  @file 
 *  @brief             功能ID定义头文件
 * 
 *  <b>文件名</b>      : FuncIdDef.h
 *  @n@n<b>版权所有</b>: 
 *  @n@n<b>作  者</b>  :
 *  @n@n<b>创建时间</b>: 2010-1-26 14:55:55
 *  @n@n<b>文件描述</b>: 
 *  @version		版本	修改者		  时间		  描述@n
 *  @n		                2010-02-25
 * 
************************************************************************************/
#ifndef _FUNC_ID_DEF_H_
#define _FUNC_ID_DEF_H_


//////////////////////////////////////////////////////////
//       共通部分
//////////////////////////////////////////////////////////
#define ASTRO_ZIWEI_FACADER_INDEX                    10000
#define ASTRO_BAZI_FACADER_INDEX                     20000
#define ASTRO_NAME_FACADER_INDEX                     30000
#define ASTRO_CONS_FACADER_INDEX                     40000
#define ASTRO_CUSTOM_FACADER_INDEX                   50000
#define ASTRO_DZ_FACADER_INDEX                       60000
#define ASTRO_PRO_FACADER_INDEX						 70000
#define ASTRO_XZDS_FACADER_INDEX					 78000
#define ASTRO_FT_FACADER_INDEX						 80000
#define ASTRO_FR_FACADER_INDEX						 85000
#define ASTRO_YCPP_FACADER_INDEX					 90000
#define ASTRO_ERROR_FACADER_INDEX                    0

// 算命功能函数索引最小值
#define ASTRO_API_MIN_INDEX                          1

// 算命功能函数索引最小值
#define ASTRO_API_MAX_INDEX                          5000


//////////////////////////////////////////////////////////
//       紫微部分
//////////////////////////////////////////////////////////

// 紫微功能函数索引最小值
#define ASTRO_ZIWEI_API_MIN_INDEX                    1
// 获取紫微一生命盘
#define ASTRO_ZIWEI_GET_LIFE_PLATE                   1
// 获取紫微大限命盘
#define ASTRO_ZIWEI_GET_DAXIAN_PLATE                 2
// 获取紫微流年命盘
#define ASTRO_ZIWEI_GET_LIUNIAN_PLATE                3
// 获取紫微流月命盘
#define ASTRO_ZIWEI_GET_LIUYUE_PLATE                 4
// 获取紫微流日命盘
#define ASTRO_ZIWEI_GET_LIURI_PLATE                  5
// 获取紫微主星信息
#define ASTRO_ZIWEI_GET_MAINSTAR_INFO                6
// 获取紫微主星信息和解释
#define ASTRO_ZIWEI_GET_MAINSTAR_INFORESULT          7
// 获取紫微格局解释
#define ASTRO_ZIWEI_GET_PATTERN_RESULT               8
// 获取紫微宫位解释(命宫、父母宫等）
#define ASTRO_ZIWEI_GET_PALACE_RESULT                9
// 获取紫微命盘解释
#define ASTRO_ZIWEI_GET_PLATE_RESULT                 10
// 获取紫微大限运势解释
#define ASTRO_ZIWEI_GET_DAXIANLUCK_RESULT            11
// 获取紫微流年运势解释
#define ASTRO_ZIWEI_GET_LIUNIANLUCK_RESULT           12
// 获取紫微流月运势解释
#define ASTRO_ZIWEI_GET_LIUYUELUCK_RESULT            13
// 获取紫微流日运势解释
#define ASTRO_ZIWEI_GET_LIURILUCK_RESULT             14

// 获取紫微大限爱情解释
#define ASTRO_ZIWEI_GET_DAXIANLOVE_RESULT            15
// 获取紫微流年爱情解释
#define ASTRO_ZIWEI_GET_LIUNIANLOVE_RESULT           16
// 获取紫微流月爱情解释
#define ASTRO_ZIWEI_GET_LIUYUELOVE_RESULT            17
// 获取紫微流日爱情解释
#define ASTRO_ZIWEI_GET_LIURILOVE_RESULT             18
// 获取紫微婚姻指南解释
#define ASTRO_ZIWEI_GET_LOVECOMPASS_RESULT           19
// 获取紫微合婚密断解释
#define ASTRO_ZIWEI_GET_HHMD_RESULT                  20
// 获取紫微命宫主星列表信息（优生择时）
#define ASTRO_ZIWEI_GET_MAINSTARINFOLIST_FORBABY     21
// 获取紫微流日命宫吉凶指数（每日提醒）
#define ASTRO_ZIWEI_GET_DAYJXTIPEXP_FORAUTOREMIND    22
// 获取一生所需要的简要流年的信息（专业版使用）
#define ASTRO_ZIWEI_GET_LIFE_SIMPLE_LIUNIAN_RESULT   23
// 获取紫微官禄宫的主星解释（大众事业成长使用）
#define ASTRO_ZIWEI_GET_GUANLUG_RESULT_FOR_SHIYE     24

// 紫微功能函数索引最大值
#define ASTRO_ZIWEI_API_MAX_INDEX                    500

// 紫微一生命运专题
#define ASTRO_ZIWEI_LIFE_TOPIC                       501
// 紫微运势专题
#define ASTRO_ZIWEI_LUCK_TOPIC                       502
// 紫微爱情专题
#define ASTRO_ZIWEI_LOVE_TOPIC                       503
// 紫微合婚专题
#define ASTRO_ZIWEI_HEHUN_TOPIC                       504

//////////////////////////////////////////////////////////
//       八字部分
//////////////////////////////////////////////////////////

// 八字功能函数索引最小值
#define ASTRO_BAZI_API_MIN_INDEX                     1000

#define ASTRO_BAZI_NAVI_PLATE						 1001
// 八字基本排盘										 
#define ASTRO_BAZI_GET_NOR_PLATE					 1002
// 八字专业排盘										 
#define ASTRO_BAZI_GET_PRO_PLATE					 1003
// 八字命局分析(断语)								 
#define ASTRO_BAZI_GET_DUAN_YU_PLATE				 1004
// 八字婚姻恋爱红皮书								 
#define ASTRO_BAZI_GET_HPS_PLATE					 1005
// 八字恋爱观										 
#define ASTRO_BAZI_GET_LAG_PLATE					 1006
// 八字夫妻宫十神									 
#define ASTRO_BAZI_GET_FQGSS_PLATE					 1007
// 八字感情运势										 
#define ASTRO_BAZI_GET_GQYS_PLATE					 1008
// 八字结婚时间点									 
#define ASTRO_BAZI_GET_JHSJD_PLATE					 1009
// 八字最佳配偶信息
#define ASTRO_BAZI_GET_ZJPOXX_PLATE					 1010
// 八字合婚
#define ASTRO_BAZI_GET_BZHH_PLATE					 1011
// 八字运势
#define ASTRO_BAZI_GET_YUNSHI_RESULT				 1012


// 八字功能函数索引最大值
#define ASTRO_BAZI_API_MAX_INDEX                     1500

// 八字一生命运专题
#define ASTRO_BAZI_LIFE_TOPIC                        1501
// 八字运势专题
#define ASTRO_BAZI_LUCK_TOPIC                        1502
// 八字爱情专题
#define ASTRO_BAZI_LOVE_TOPIC                        1503


//////////////////////////////////////////////////////////
//       姓名部分
//////////////////////////////////////////////////////////

// 姓名功能函数索引最小值
#define ASTRO_NAME_API_MIN_INDEX                     2000

// 获取姓名测试命盘
#define ASTRO_NAME_GET_TEST_PLATE                    2001

// 获取姓名测试解释
#define ASTRO_NAME_GET_TEST_RESULT                   2002

// 获得姓名五格(缘份匹配-姓名匹配使用)
#define ASTRO_NAME_GET_TEST_FIVEPATTEN_RESULT        2003

// 获取姓名易心测试解释
#define ASTRO_NAME_GET_YIXIN_TEST_RESULT			 2004

// 获取姓名易心事业测试解释
#define ASTRO_NAME_GET_YIXIN_CAREER_RESULT			 2005

// 获取姓名易心健康测试解释
#define ASTRO_NAME_GET_YIXIN_HEALTH_RESULT			 2006

// 获取姓名易心婚姻测试解释
#define ASTRO_NAME_GET_YIXIN_LOVE_RESULT			 2007

// 获取姓名易心命运测试解释
#define ASTRO_NAME_GET_YIXIN_FATE_RESULT			 2008

// 手机版--姓名测试的解释
#define ASTRO_NAME_MOBILE_TEST_RESULT                2101

// 姓名匹配--姓氏字典--汉字简单信息
#define ASTRO_NAME_GET_SIMPLE_CHARACTER_INFO         2102

// 姓名功能函数索引最大值
#define ASTRO_NAME_API_MAX_INDEX                     2500


// 姓名测试专题
#define ASTRO_NAME_TEST_TOPIC                        2501


//////////////////////////////////////////////////////////
//       星座部分
//////////////////////////////////////////////////////////

// 星座功能函数索引最小值
#define ASTRO_CONS_API_MIN_INDEX                     3000

// 获取星座解释信息
#define ASTRO_CONS_GET_DEFAULT_RESULT                3001
#define ASTRO_CONS_GET_DEFAULT_RESULT_BYIDX          3002

// 获取星座血型信息
#define ASTRO_CONS_GET_BLOOD_RESULT                  3003
#define ASTRO_CONS_GET_BLOOD_RESULT_BYIDX            3004

// 获取星座匹配信息
#define ASTRO_CONS_GET_MATCH_RESULT                  3005
#define ASTRO_CONS_GET_MATCH_RESULT_BYIDX            3006

// 星座功能函数索引最大值
#define ASTRO_CONS_API_MAX_INDEX                     3500

// 星座测试专题
#define ASTRO_CONS_INFO_TOPIC                        3501


//////////////////////////////////////////////////////////
//      民俗部分
//////////////////////////////////////////////////////////

// 民俗功能函数索引最小值
#define ASTRO_CUSTOM_API_MIN_INDEX                   4000

// 获取冲宜忌信息
#define ASTRO_CUSTOM_GET_CYJ_RESULT                  4001
// 获取每日宜忌信息
#define ASTRO_CUSTOM_GET_EDADVICE_RESULT             4002
// 择选吉日
#define ASTRO_CUSTOM_GET_GOODDAY_RESULT              4003
// 今日吉时
#define ASTRO_CUSTOM_GET_TDYGOODTIME_RESULT          4004
//获取手机吉凶判断信息
#define ASTRO_CUSTOM_GET_TELEPHONE_RESULT            4006
//获取周公解梦结果
#define ASTRO_CUSTOM_GET_ZHOUGONG_RESULT             4007
//获取星座匹配结果
#define ASTRO_CUSTOM_GET_XINGZUO_RESULT              4008
//获取生肖运势结果
#define ASTRO_CUSTOM_GET_SXYUNSHI_RESULT			 4009
//获取星座运势运势
#define ASTRO_CUSTOM_GET_XZYUNSHI_RESULT			 4010
//获取星座本月运势
#define ASTRO_CUSTOM_GET_XZCURMONTH_RESULT			 4011
//获取桌面贴黄道吉日关键字搜索得出相应的小标题原文
#define ASTRO_ZMTCUSTOM_GET_ORGNAME_RESULT			 4012
//获取桌面贴黄道吉日常用查询词汇
#define ASTRO_ZMTCUSTOM_GET_COMUSENAME_RESULT		 4013
// 星座功能函数索引最大值
#define ASTRO_CUSTOM_API_MAX_INDEX                   4500

// 每日宜忌专题
#define ASTRO_CUSTOM_EVERYDAYADVICE_TOPIC            4501


//////////////////////////////////////////////////////////
//      大众版部分
//////////////////////////////////////////////////////////

//大众模块功能函数索引最小值
#define ASTRO_DZ_API_MIN_INDEX                       5000

//获人格特质结果信息
#define ASTRO_RENGETEZH_GET_RESULT                   5001

// 获取流年运势解释
#define ASTRO_DZYS_GET_LIUNIAN_RESULT                5010

// 获取流月运势解释  
#define ASTRO_DZYS_GET_LIUYUE_RESULT                 5011

// 获取每日运势解释
#define ASTRO_DZYS_GET_DAY_RESULT                    5012

// 获取爱情桃花解释
#define ASTRO_DZ_LOVE_TAOHUA_RESULT					 5013

// 获取大众版合婚解释
#define ASTRO_DZ_LOVE_HE_HUN_RESULT					 5014

//获取个人主页属性结果
#define ASTRO_DZ_GET_HOSTPAGE_RESULT                 5015

// 获取流年运势紫微十二宫的吉凶指数--手机运势用
#define ASTRO_DZYS_GET_LIUNIAN_12GVALUE              5016

// 获取流月运势紫微十二宫的吉凶指数--手机运势用
#define ASTRO_DZYS_GET_LIUYUE_12GVALUE               5017

// 获取流日运势紫微十二宫的吉凶指数--手机运势用
#define ASTRO_DZYS_GET_LIURI_12GVALUE                5018

// 获取事业专题的结果
#define ASTRO_DZ_GET_SHIYE_RESULT                    5019

// 获取姓名匹配人员信息
#define ASTRO_DZ_GET_NAMEPD_RESULT                   5020

// 获取财富专题的结果
#define ASTRO_DZ_GET_CAIFU_RESULT                    5021

// 获取大众流日运势的解释（根据紫微主星+命宫地支+流日天干，一共1200条解释，每天都不同）
#define ASTRO_DZYS_GET_DAY_RESULT_EX                 5022

// 获取大众流月运势的解释（根据紫微主星+命宫地支+流月天干，一共1200条解释，每月都不同）
#define ASTRO_DZYS_GET_MONTH_RESULT_EX               5023

// 获取流日明日解释
#define ASTRO_DZYS_GET_TOMORROW_RESULT               5024

// 增加开运的流日幸运提示信息
#define ASTRO_DZ_GET_DAY_LUCKY_INFO                  5025

//手机版获取开运指南、今日简评
#define ASTRO_DZ_GET_JIANPING_AND_LUCKY_RESULT       5026

//大众模块功能函数索引最大值
#define ASTRO_DZ_API_MAX_INDEX					     5500

//八字运势主题
#define  ASTRO_DZ_BZYUNSHI_TOPIC                     5501

// 人格特质主体专题
#define ASTRO_DZ_REGETEZH_INFO_TOPIC                 5502

// 爱情桃花专题
#define ASTRO_DZ_LOVE_TAOHUA_TOPIC					 5503

// 合婚专题
#define ASTRO_DZ_HE_HUN_TOPIC					     5504

// 运势专题紫微部分数据
#define ASTRO_DZ_YUNSHI_ZW_TOPIC                     5505

//创建八字紫薇调和实例类
#define  ASTRO_DZ_BZANDZW_YUNSH_TOPIC                5506

#define  ASTRO_DZ_HOSTPAGE_TOPIC                     5507

// 创建大众事业部分的数据
#define  ASTRO_DZ_SHIYE_TOPIC                        5508

// 创建大众姓名匹配部分的数据
#define  ASTRO_DZ_NAMEPD_TOPIC                        5509

// 创建大众财富部分的数据
#define  ASTRO_DZ_CAIFU_TOPIC                        5510

//////////////////////////////////////////////////////////
//      专业版部分
//////////////////////////////////////////////////////////

//专业版模块功能函数索引最小值
#define ASTRO_PRO_API_MIN_INDEX                       6000

//获专业版八字结果信息
#define ASTRO_PRO_BZ_GET_RESULT                       6001
//获专业版紫微结果信息
#define ASTRO_PRO_ZW_GET_RESULT                       6002
//获专业版姓名结果信息
#define ASTRO_PRO_XM_GET_RESULT                       6003
//获取专业版用户编辑后命书信息
#define ASTRO_PRO_MS_GET_RESULT						  6004
//保存专业版用户编辑后命书信息
#define ASTRO_PRO_MS_SET_RESULT						  6005

//专业版模块功能函数索引最大值
#define ASTRO_PRO_API_MAX_INDEX                       6500


//专业版八字主题
#define  ASTRO_PRO_BZ_TOPIC                           6501
//专业版紫微主题
#define  ASTRO_PRO_ZW_TOPIC                           6502
//专业版姓名主题
#define  ASTRO_PRO_XM_TOPIC                           6503


//////////////////////////////////////////////////////////
//      事件反推部分
//////////////////////////////////////////////////////////

//事件反推模块功能函数索引最小值
#define ASTRO_REV_API_MIN_INDEX                       7000

//获专业版事件反推结果信息
#define ASTRO_FT_GQ_RESULT							  7001
#define ASTRO_FT_SY_RESULT							  7002
#define ASTRO_FT_ZF_RESULT							  7003
#define ASTRO_FT_DJ_RESULT							  7004
#define ASTRO_FT_DX_RESULT							  7005

//事件反推模块功能函数索引最大值
#define ASTRO_REV_API_MAX_INDEX                       7500

//专业版事件反推主题
#define  ASTRO_PRO_REV_TOPIC                          7501


//////////////////////////////////////////////////////////
//      好友接口部分
//////////////////////////////////////////////////////////

//好友接口模块功能函数索引最小值
#define ASTRO_FR_API_MIN_INDEX                       7600

#define ASTRO_FR_SAVE_RESULT						  7601
#define ASTRO_FR_GET_RESULT							  7602
#define ASTRO_FR_SEAR_RESULT						  7603
#define ASTRO_FR_PD_RESULT							  7604

//好友接口模块功能函数索引最大值
#define ASTRO_FR_API_MAX_INDEX                       7700

//专业版事件反推主题
#define  ASTRO_PRO_FR_TOPIC                          7701

//////////////////////////////////////////////////////////
//      星座大师接口部分
//////////////////////////////////////////////////////////

//星座大师接口模块功能函数索引最小值
#define ASTRO_XZDS_API_MIN_INDEX                       7800
//星座排盘
#define ASTRO_XZDS_PP_RESULT						   7801
//各行星在星座的解释
#define ASTRO_XZDS_XXXZ_RESULT						   7802
//各行星在12宫位的解释
#define ASTRO_XZDS_XXGW_RESULT						   7803
//行星相位角度的解释
#define ASTRO_XZDS_XXXW_RESULT						   7804
//宫位在星座的解释
#define ASTRO_XZDS_GWXZ_RESULT						   7805

//星座大师接口模块功能函数索引最大值
#define ASTRO_XZDS_API_MAX_INDEX                       7850

//星座大师主题
#define  ASTRO_XZDS_PP_TOPIC                           7851
//行星概况的主题
#define ASTRO_XZDS_XXGK_TOPIC 						   7852

//////////////////////////////////////////////////////////
//      交易管理部分
//////////////////////////////////////////////////////////

//交易管理模块功能函数索引最小值
#define ASTRO_MANGER_API_MIN_INDEX                       8000

//交易管理结果信息
#define ASTRO_MANGER_REV_GET_RESULT                      8001

//交易管理模块功能函数索引最大值
#define ASTRO_MANGER_API_MAX_INDEX                       8500

//交易管理主题
#define  ASTRO_MANGER_REV_TOPIC                          8501

//////////////////////////////////////////////////////////
//      预测排盘部分
//////////////////////////////////////////////////////////
#define ASTRO_YCPP_API_MIN_INDEX						9000

//获取排盘结果
#define ASTRO_YCPP_LYPP_RESULT							9001
#define ASTRO_YCPP_MHPP_RESULT							9002
#define ASTRO_YCPP_FSPP_RESULT							9003
#define ASTRO_YCPP_QMPP_RESULT							9004

#define ASTRO_YCPP_API_MAX_INDEX						9500

//预测排盘主题
#define  ASTRO_YCPP_LY_TOPIC							9501
#define  ASTRO_YCPP_MH_TOPIC							9502
#define  ASTRO_YCPP_FS_TOPIC							9503
#define  ASTRO_YCPP_QM_TOPIC							9504


#pragma mark -
#pragma mark 积分消费项目 
//姓名分析(综合)		
#define	 ASTRO_CUMS_NAMEPARSE_ALL						42004
//姓名分析(事业)	
#define	 ASTRO_CUMS_NAMEPARSE_WORK						42005
//姓名分析(健康)	
#define	 ASTRO_CUMS_NAMEPARSE_HEALTH					42006
//姓名分析(婚姻)	
#define	 ASTRO_CUMS_NAMEPARSE_MARRY						42007
//姓名分析(命运特点)
#define	 ASTRO_CUMS_NAMEPARSE_FATECHAR					42008	
//姓名匹配		
#define  ASTRO_CUMS_NAMEMATCH							42009
//流月流日运势	
#define	 ASTRO_CUMS_LIURIYUE							45011
//流年运势		
#define	 ASTRO_CUMS_LIUNIAN								45010
//专业版流月流日运势	
#define	 ASTRO_CUMS_PRO_LIURIYUE						40013
//专业版流年运势		
#define	 ASTRO_CUMS_PRO_LIUNIAN							40012
//财富运势
#define	 ASTRO_CUMS_FORTUNE 							42015
//事业成长
#define	 ASTRO_CUMS_CAREER						    	42014


#endif // end of defined _FUNC_ID_DEF_H_


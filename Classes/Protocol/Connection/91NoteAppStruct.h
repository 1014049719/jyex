#ifndef __91NOTEAPPSTRUCT_H_H_
#define __91NOTEAPPSTRUCT_H_H_

#pragma pack(push, 1)

enum
{
	AS_OPCODE_LOGIN_REQ=3, //客户端，登录请求
	AS_OPCODE_LOGIN_RSP=4, //服务器：登录反馈
};

enum
{
	AS_OPTYPE_ENGLISH=1,	//English...
	AS_OPTYPE_NOTE=2,		//Note...
	AS_OPTYPE_PICTURE=3,	//Picture...
};

#define  AS_APP_BUF_SIZE 1024

typedef struct _tagPackInfo
    {
        unsigned short wAsynFlag; //同步标志为0x5D5D
        unsigned short wMsgSize;   //整个数据包的大小
        unsigned short wOpCode;    //操作码
        unsigned short wDivFlag;   //有无分包标志
        unsigned char  wCtrlFlag;    
        unsigned int   dwDataSize;		 //压缩数据的原始大小
        unsigned char  btOpSplitType;	     //业务包分包类型0：无业务分包1：业务分包还没结束2：业务分包结束
        unsigned short wVersion;            //控制信息,包括客户端版本号,数据包是否压缩等
    }AS_PACKINFO_HEADER,*PAS_PACKINFO_HEADER;


//登录请求 操作码是 3
typedef struct _tagLoginAppSrvReq//登录包(服务端如果验证失败,则dwUserID=0,dwData=0)
    {
        //Add by LinQingtao 2008.11.20
        char	    strUserName[128];	//用户名
        //End of Addition 2008.11.20
        unsigned int       dwGAID;             //帐号ID
        unsigned int	    dwUserID;	//用户应用ID  
        unsigned int	    dwData;		//用户账户Key
        short       wOpType;            //业务类型:英语 1 ;NOTE 2;PICTURE 3; 
        unsigned short        wAssistInfo;        //辅助信息
        
    }AS_LOGINAPPSRVREQ, *PAS_LOGINAPPSRVREQ;

//登录反馈  操作码是 4
typedef struct _tagLoginAppSrvRsp //登录反馈
    {
        unsigned int    dwUserid; //如果登录失败 id=0;
        char     AppServerIP[32];
        unsigned int    GAID;
        unsigned int    dwKey;
    }AS_LOGINAPPSRVRSP,*PAS_LOGINAPPSRVRSP;

//应用层数据结构
typedef struct _tagASApp
    {
        union
        {
            AS_LOGINAPPSRVREQ LoginReq;//客户端，登录
            AS_LOGINAPPSRVRSP LoginRsp;//服务器，登录反馈
            
            char Buf[AS_APP_BUF_SIZE];
        };
    }AS_APP_PACK,*PAS_APP_PACK;

//整个数据包的结构
typedef struct _tagAppServerPcb
    {
        AS_PACKINFO_HEADER MsgHdr;//消息头
        AS_APP_PACK App;//应用层数据
        
    }AS_PACKINFO,*PAS_PACKINFO;

//应用层数据结构，包括操作码和数据包大小
typedef struct _tagASAppWithType
    {
        unsigned short wOpCode;	 //操作码
        unsigned int dwDataSize;//“原始数据包”（不是分包）的大小
        AS_APP_PACK App;
    }AS_APP_PACK_WITH_TYPE,*PAS_APP_PACK_WITH_TYPE;


#pragma  pack(pop)

#endif
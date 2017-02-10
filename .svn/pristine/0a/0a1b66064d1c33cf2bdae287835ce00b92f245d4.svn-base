/*************************************************
 **
 **
 **author:	vforkk
 **date:		2009-07-15
 **describe:	登陆负载均衡服务器的数据包结构
 **************************************************/

#pragma once
#pragma pack(push, 1)


enum
{
	DATA_TYPE_ERRO_QUIT				 = 0,	 //错误退出，（只用于程序，不属于通信协议的一部分）
	DATA_TYPE_ERRO_NOTIFY            = 60000,//服务器返回   错误信息通知 
	DATA_TYPE_EXCHANG_KEY            = 60001,//客户端发送   当前版本号、手机的加密KEY,//服务器返回   MobileServer的加密KEY 
	DATA_TYPE_LOGIN_ACCOUNT_SERVER   = 60002,//客户端发送   应用服务类型、用户名 、密码、负载均衡器的名字
	DATA_TYPE_SENDBACK_APPSERVERINFO = 60003,//服务器返回   应用服务器的IP地址、端口号、用户的帐号ID、KeyCode 
	DATA_TYPE_VERSION_ERROR          = 60007,//服务器返回   客户端最新版本号
};

//传输层
typedef struct _tagNoteLoginLbsHeader
	{
		union
		{
			unsigned short wStartFlag;
			struct
			{
				unsigned char btStartFlag1;
				unsigned char btStartFlag2;
			}bytes;
		};
		unsigned short wMsgSize;		//整个数据包大小，包括消息头
		unsigned short wConnectFlag;	//应用层消息类型
	}NOTE_LOGIN_LBS_HEADER,*PNOTE_LOGIN_LBS_HEADER;

/***********************************************
 ******************* 应用层 *********************
 ************************************************/

#define MAX_LBS_APP_DATA_SIZE 1024	//由于目前有两个域大小上限暂无限制，根据与唐陈平沟通，实际传输过程中的情况，采用1024已经足够了。。但还是需要服务器端再进一步文档限制的。

//错误信息通知，6001
typedef struct _tagLbsErrInfo
	{
		char szInfo[MAX_LBS_APP_DATA_SIZE];
	}NOTE_LOGIN_LBS_ERRINFO;

//客户端 SEND TO 服务端，用于Des加密的（客户端的）密钥，6001
typedef struct _tagLbsMobileDeskey
	{	
		unsigned int dwVersion;   //客户端的当前版本号 
		unsigned char  btDesKey[64];//手机的DESKEY －－用公钥进行加密
	}NOTE_LOGIN_LBS_MOBILE_DESKEY,*PNOTE_LOGIN_LBS_MOBILE_DESKEY;

//服务端 SEND TO 客户端，用于Des加密的（服务器的）密钥，6002
typedef struct 
	{	
		unsigned char btDesKey[24];//MobileServer的DESKEY －－用手机的DESKEY加密
	}NOTE_LOGIN_LBS_MOBILESERVER_DESKEY,*PNOTE_LOGIN_LBS_MOBILESERVER_DESKEY;

//全部信息用手机的DESKEY加密，6003
typedef struct _tagNoteLoginLbsReply   
	{
		unsigned short    wSize;
		unsigned short    wType;
		unsigned int   idAccount;                 // =0表示失败
		unsigned int   dwData;                    // 认证数据,或者错误ID
		int    nServerPort;                 // 成功是游服端口,失败未用
		unsigned  int dwUin;               // 负载均衡器返回的idUser
		char   szInfo[32];                 // 成功是IP,失败是错误提示
	}NOTE_LOGIN_LBS_REPLY,*PNOTE_LOGIN_LBS_REPLY;

//客户端最新版本信息，服务器发送给客户端，6007
typedef struct _tagVersion
	{
		unsigned int dwVersion;
	}NOTE_LOGIN_LBS_VERSION,*PNOTE_LOGIN_LBS_VERSION;

typedef struct _tagAccServer
	{
		char * strSvrType;//服务类型
		char * strUserName;//用户名
		char * strPassword;//密码
		char * strSvrName;//负载均衡服务器名
	} NOTE_LOGIN_LBS_ACCOUNT_SERVER,*PNOTE_LOGIN_LBS_ACCOUNT_SERVER;

//应用层的结构
typedef struct _tagNoteLoginLbsAppLayer
	{
		union
		{
			NOTE_LOGIN_LBS_ERRINFO ErrInfo;						//错误信息
			NOTE_LOGIN_LBS_MOBILE_DESKEY MobDesKey;				//客户端Des密钥
			NOTE_LOGIN_LBS_MOBILESERVER_DESKEY MobSrvDesKey;	//服务器端Des密钥
			NOTE_LOGIN_LBS_REPLY SrvReply;						//服务器返回的应答数据
			NOTE_LOGIN_LBS_VERSION Ver;							//服务器返回的版本信息（客户端最新版本号）	
			//		NOTE_LOGIN_LBS_ACCOUNT_SERVER AccSvr;				//应用服务类型、用户名 、密码、负载均衡器的名字
			
			unsigned char Buf[MAX_LBS_APP_DATA_SIZE];//整个应用层的数据缓冲区
		};
	}NOTE_LOGIN_LBS_APP_LAYER,*PNOTE_LOGIN_LBS_APP_LAYER;

//整个数据包的结构
typedef struct _tagNoteLoginLbsPackage
	{
		NOTE_LOGIN_LBS_HEADER MsgHdr;//数据包头
		NOTE_LOGIN_LBS_APP_LAYER AppLayer;//应用层数据
	}NOTE_LOGIN_LBS_PACKAGE,*PNOTE_LOGIN_PACKAGE;


//应用层的结构,包含消息类型
typedef struct _tagNoteLoginLbsAppWithType
	{
		unsigned short wAppSize;		//应用层有效数据大小
		unsigned short wConnectFlag;	//应用层消息类型
		NOTE_LOGIN_LBS_APP_LAYER App;
	}NOTE_LOGIN_LBS_APP_WITH_TYPE,*PNOTE_LOGIN_LBS_APP_WITH_TYPE;


#pragma pack(pop)
























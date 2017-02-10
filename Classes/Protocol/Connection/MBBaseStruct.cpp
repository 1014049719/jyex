/*
 *  MBBaseStruct.cpp
 *  pass91
 *
 *  Created by Zhaolin He on 09-9-7.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#import "MBBaseStruct.h"
#import "91NoteAppStruct.h"

CMBUpLoadCommonSglKeyAck::CMBUpLoadCommonSglKeyAck()
{
    
}

CMBUpLoadCommonSglKeyAck::~CMBUpLoadCommonSglKeyAck()
{
    ReleaseBuf();
}

int CMBUpLoadCommonSglKeyAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBUpLoadCommonSglKeyAck::ReleaseBuf()
{
//    std::list<CSglKeyUpLoadRslt>::iterator it = m_lstPUpLoadRslt.begin();
//    while (it != m_lstPUpLoadRslt.end())
//    {
//        // CHECK: [czc] [时间: 2009-07-28]【NULL == *it】
////        delete (*it);
////        *it = NULL;
//        ++it;
//    }
}

int CMBUpLoadCommonSglKeyAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<CSglKeyUpLoadRslt>::iterator it = m_lstPUpLoadRslt.begin();
    while (m_lstPUpLoadRslt.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            // CHECK: [czc] [时间: 2009-07-28]【写日志和容错处理】
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    uint32_t unCnt = (uint32_t)m_lstPUpLoadRslt.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPUpLoadRslt.begin();
    while (m_lstPUpLoadRslt.end() != it)
    {
        // CHECK: [czc] [时间: 2009-07-28]【NULL == *it,使用*it->GetObjectSize(unAtomLen)是否比使用sizeof兼容性更高？】
        memcpy(p, &(*it), sizeof(CSglKeyUpLoadRslt));
        p += sizeof(CSglKeyUpLoadRslt);      
        ++it;
    }
    
    return RET_SUCCESS;
    
}


int CMBUpLoadCommonSglKeyAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
		// CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((uint32_t*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode); 
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPUpLoadRslt.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CSglKeyUpLoadRslt);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CSglKeyUpLoadRslt pSglKeyUpLoadRslt;
        // CHECK: [czc] [时间: 2009-07-28]【NULL == pSglKeyUplodaRslt】
        memcpy(&pSglKeyUpLoadRslt, p, sizeof(CSglKeyUpLoadRslt));
        p += sizeof(CSglKeyUpLoadRslt);
        
        m_lstPUpLoadRslt.push_back(pSglKeyUpLoadRslt);
    }
    
    return RET_SUCCESS;
}


//   响应
CMBUpLoadCommonDblKeyAck::CMBUpLoadCommonDblKeyAck()
{
    
}

CMBUpLoadCommonDblKeyAck::~CMBUpLoadCommonDblKeyAck()
{
    ReleaseBuf();
}

int CMBUpLoadCommonDblKeyAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBUpLoadCommonDblKeyAck::ReleaseBuf()
{
//    std::list<CDblKeyUpLoadRslt>::iterator it = m_lstPUpLoadRslt.begin();
//    while (it != m_lstPUpLoadRslt.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
}

int CMBUpLoadCommonDblKeyAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<CDblKeyUpLoadRslt>::iterator it = m_lstPUpLoadRslt.begin();
    while (m_lstPUpLoadRslt.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            // CHECK: [czc] [时间: 2009-07-28]【同上】
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    uint32_t unCnt = (uint32_t)m_lstPUpLoadRslt.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPUpLoadRslt.begin();
    while (m_lstPUpLoadRslt.end() != it)
    {
        // CHECK: [czc] [时间: 2009-07-28]【同上】
        memcpy(p, &(*it), sizeof(CDblKeyUpLoadRslt));
        p += sizeof(CDblKeyUpLoadRslt);      
        ++it;
    }
    
    return RET_SUCCESS;
    
}


int CMBUpLoadCommonDblKeyAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
		// CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int32_t*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPUpLoadRslt.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CDblKeyUpLoadRslt);
        if (unOffSet > unLen)
        {
			// CHECK: [czc] [时间: 2009-07-28]【写日志】
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CDblKeyUpLoadRslt pDblKeyUpLoadRslt;
        // CHECK: [czc] [时间: 2009-07-28]【同上】
        memcpy(&pDblKeyUpLoadRslt, p, sizeof(CDblKeyUpLoadRslt));
        p += sizeof(CDblKeyUpLoadRslt);
        
        m_lstPUpLoadRslt.push_back(pDblKeyUpLoadRslt);
    }
    
    return RET_SUCCESS;
}



CMBRspURL::CMBRspURL()
{
    m_pwszURL = NULL;
}

CMBRspURL::~CMBRspURL()
{
    ReleaseBuf();
}

int CMBRspURL::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBRspURL::ReleaseBuf()
{
    if (NULL != m_pwszURL)
    {
        delete[] m_pwszURL;
        m_pwszURL = NULL;
    }
}

int CMBRspURL::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    uint32_t unStrLen = 0;
    
    if (NULL == m_pwszURL)
    {
		// CHECK: [czc] [时间: 2009-07-28]【写日志】
		return RET_MB_MSG_DECODE_ERR;
    }
    
    // CHECK: [czc] [时间: 2009-07-28]【考虑使用_tcslen和 sizeof(Tchar)】
    unStrLen = (wcslen_m((char *)m_pwszURL) + 1) * 2;
    unLen += unStrLen;
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);

    wcscpy_m(p, (char*)m_pwszURL);    
    p += unStrLen;
    
    return iRet;
    
}


int CMBRspURL::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
	
	unLen=unLen-sizeof(AS_PACKINFO_HEADER);
    unsigned int unMinLen = this->GetFixedLen();
    unMinLen += 2;//m_pwszURL至少要占一个"\0"
	
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
	
    char *p = pRev;
	p+=sizeof(AS_PACKINFO_HEADER);
	
    unsigned int unOffSet = 0;//这个在没有指针的类中其实没有用
	
    m_dwConnectionID = *((unsigned int*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
	
    m_dwDbID = *((unsigned int*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
	
    m_dwAppUserID = *((unsigned int*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
	
    m_nRetCode = *((int*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
	
    unsigned int unStrLen = (wcslen_m((char*)p) + 1) * 2;
    m_pwszURL = new unichar[unStrLen / 2];
    memcpy(m_pwszURL, p, unStrLen);    
	
    return RET_SUCCESS;
}

//获取一个用户下版本号大于m_dwCurVer的某一类资源的全部信息
CMBGetAllRcdReq::CMBGetAllRcdReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_dwCurVer          = 0;
}

CMBGetAllRcdReq::~CMBGetAllRcdReq()
{
    ReleaseBuf();
}

int CMBGetAllRcdReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_dwCurVer));
}

void CMBGetAllRcdReq::ReleaseBuf()
{    
}

int CMBGetAllRcdReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    return iRet;
    
}


int CMBGetAllRcdReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_dwCurVer = *((uint32_t*)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer); 
    
    return RET_SUCCESS;
}


//获取一个用户下版本号大于m_dwFromVer的最新的m_unLimitCnt条 资源
CMBGetLimitRcdReq::CMBGetLimitRcdReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_dwFromVer         = 0;
    m_unLimitCnt        = 0;
}

CMBGetLimitRcdReq::~CMBGetLimitRcdReq()
{
    ReleaseBuf();
}

int CMBGetLimitRcdReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) 
            + sizeof(m_dwAppUserID) + sizeof(m_dwFromVer) + sizeof(m_unLimitCnt));
}

void CMBGetLimitRcdReq::ReleaseBuf()
{    
}

int CMBGetLimitRcdReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_dwFromVer, sizeof(m_dwFromVer));
    p += sizeof(m_dwFromVer);
    
    memcpy(p, &m_unLimitCnt, sizeof(m_unLimitCnt));
    p += sizeof(m_unLimitCnt);
    
    return iRet;
    
}


int CMBGetLimitRcdReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_dwFromVer = *((uint32_t*)p);
    p += sizeof(m_dwFromVer);
    unOffSet += sizeof(m_dwFromVer); 
    
    m_unLimitCnt = *((uint32_t*)p);
    p += sizeof(m_unLimitCnt);
    unOffSet += sizeof(m_unLimitCnt); 
    
    return RET_SUCCESS;
}

// 获取文件夹列表  请求
CMBSubDirListReq::CMBSubDirListReq()
{
    m_dwConnectionID    = 0;	//链路ID
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0
    m_dwAppUserID       = 0;      //本次查询数据的用户ID
    m_dwVerFrom         = 0;
    m_guidDir           = GUID_NULL;
    
}

CMBSubDirListReq::~CMBSubDirListReq()
{
    ReleaseBuf();
}

int CMBSubDirListReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_guidDir) + sizeof(m_dwVerFrom));
}

void CMBSubDirListReq::ReleaseBuf()
{
    
}

int CMBSubDirListReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidDir, sizeof(m_guidDir));
    p += sizeof(m_guidDir);  
    
    memcpy(p, &m_dwVerFrom, sizeof(m_dwVerFrom));
    p += sizeof(m_dwVerFrom);
    
    return RET_SUCCESS;
}

int CMBSubDirListReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidDir = *((GUID *)p);
    p += sizeof(m_guidDir);
    unOffSet += sizeof(m_guidDir);
    
    m_dwVerFrom = *((uint32_t*)p);
    p += sizeof(m_dwVerFrom);
    unOffSet += sizeof(m_dwVerFrom);
    
    return RET_SUCCESS;
}


// 获取文件夹列表  响应
CMBSubDirListAck::CMBSubDirListAck()
{
    m_dwConnectionID    = 0;	//链路ID
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0
    m_dwAppUserID       = 0;      //本次查询数据的用户ID
    m_nRetCode          = 0;
    
    m_lstPMBCateInfo.clear();
    
}

CMBSubDirListAck::~CMBSubDirListAck()
{
    ReleaseBuf();
}

int CMBSubDirListAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBSubDirListAck::ReleaseBuf()
{
//    std::list<CMBCateInfo>::iterator it = m_lstPMBCateInfo.begin();
//    
//    while (it != m_lstPMBCateInfo.end())
//    {
//        delete (*it);
//        (*it) = NULL;
//        ++it;
//    }
    m_lstPMBCateInfo.clear();
}

int CMBSubDirListAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<CMBCateInfo>::iterator it = m_lstPMBCateInfo.begin();
    while (m_lstPMBCateInfo.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);    
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    uint32_t unCnt = (uint32_t)m_lstPMBCateInfo.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPMBCateInfo.begin();
    while (m_lstPMBCateInfo.end() != it)
    {
        memcpy(p, &(*it), offsetof(CMBCateInfo, strName));
        p += offsetof(CMBCateInfo, strName);
        
        //wcscpy_m(p, (char*)(*it)->pwszName);
        wcscpy_m(p, (char*)(*it).strName.c_str());
        
        p += ((*it).strName.length() + 1) * 2;
        ++it;
    }
    
    return RET_SUCCESS;
}

int CMBSubDirListAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPMBCateInfo.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(CMBCateInfo, strName);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CMBCateInfo pMBCateInfo;
        memcpy(&pMBCateInfo, p, offsetof(CMBCateInfo, strName));
        p += offsetof(CMBCateInfo, strName);
        
        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
//        pMBCateInfo->pwszName = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBCateInfo->pwszName, p, unStrLen);
        pMBCateInfo.strName = (unichar*)p;
        
        p += unStrLen;
        
        m_lstPMBCateInfo.push_back(pMBCateInfo);
    }
    
    return RET_SUCCESS;
    
}

//  请求
CMBA2BListReq::CMBA2BListReq()
{
}

CMBA2BListReq::~CMBA2BListReq()
{
    ReleaseBuf();
}

int CMBA2BListReq::GetFixedLen()
{
    // CHECK: [czc] [时间: 2009-07-28]【可否直接使用sizeof(CMBA2BListReq)？】
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_guidA) + sizeof(m_dwVerFrom));
}

void CMBA2BListReq::ReleaseBuf()
{
    
}

int CMBA2BListReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidA, sizeof(m_guidA));
    p += sizeof(m_guidA);   
    
    memcpy(p, &m_dwVerFrom, sizeof(m_dwVerFrom));
    p += sizeof(m_dwVerFrom);
    
    return RET_SUCCESS;
}

int CMBA2BListReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidA = *((GUID *)p);
    p += sizeof(m_guidA);
    unOffSet += sizeof(m_guidA);  
    
    m_dwVerFrom = *((uint32_t*)p);
    p += sizeof(m_dwVerFrom);
    unOffSet += sizeof(m_dwVerFrom);
    
    return RET_SUCCESS;
    
}


//   响应
CMBA2BListAck::CMBA2BListAck()
{
    m_dwConnectionID    = 0;	//链路ID
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0
    m_dwAppUserID       = 0;      //本次查询数据的用户ID
    m_nRetCode          = 0;
    
    m_lstPA2BInfo.clear();
    
}

CMBA2BListAck::~CMBA2BListAck()
{
    ReleaseBuf();
}

int CMBA2BListAck::GetFixedLen()
{
    // CHECK: [czc] [时间: 2009-07-28]【可否使用offsetof(class CMBA2BListAck, m_lstPA2BInfo)】
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBA2BListAck::ReleaseBuf()
{
//    std::list<CMBA2BInfo>::iterator it = m_lstPA2BInfo.begin();
//    
//    while (it != m_lstPA2BInfo.end())
//    {
//        // CHECK: [czc] [时间: 2009-07-28]【×it == NULL?】
//        delete (*it);
//        (*it) = NULL;
//        ++it;
//    }
//    m_lstPA2BInfo.clear();
}

int CMBA2BListAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<CMBA2BInfo>::iterator it = m_lstPA2BInfo.begin();
    while (m_lstPA2BInfo.end() != it)
    {
        // CHECK: [czc] [时间: 2009-07-28]【NULL == *it】
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            // CHECK: [czc] [时间: 2009-07-28]【写日志，如果考虑容错处理，一个*it错误，是否可以继续把其他的发送出去？】
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);    
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    uint32_t unCnt = (uint32_t)m_lstPA2BInfo.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPA2BInfo.begin();
    while (m_lstPA2BInfo.end() != it)
    {
        // CHECK: [czc] [时间: 2009-07-28]【NULL == *it,使用*it->GetObjectSize(unAtomLen)是否比使用sizeof兼容性更高？】
        memcpy(p, &(*it), sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);
        
        ++it;
    }
    
    return RET_SUCCESS;
}

int CMBA2BListAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPA2BInfo.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CMBA2BInfo);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CMBA2BInfo pMBA2BInfo;
        memcpy(&pMBA2BInfo, p, sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);      
        
        m_lstPA2BInfo.push_back(pMBA2BInfo);
    }
    
    return RET_SUCCESS;
    
}

// 获取文件夹列表  请求
CMBGetDefCataListReq::CMBGetDefCataListReq()
{
    m_dwConnectionID    = 0;	//链路ID
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0
    m_dwAppUserID       = 0;      //本次查询数据的用户ID    
}

CMBGetDefCataListReq::~CMBGetDefCataListReq()
{
    ReleaseBuf();
}

int CMBGetDefCataListReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID));
}

void CMBGetDefCataListReq::ReleaseBuf()
{
    
}

int CMBGetDefCataListReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);    
    
    return RET_SUCCESS;
}

int CMBGetDefCataListReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);   
    
    return RET_SUCCESS;
}

//获取一个用户下版本号大于m_dwFromVer的最新的m_unLimitCnt条 资源
CMBGetItemInfoByNoteIDReq::CMBGetItemInfoByNoteIDReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_guidNote          = GUID_NULL;    
}

CMBGetItemInfoByNoteIDReq::~CMBGetItemInfoByNoteIDReq()
{
    ReleaseBuf();
}

int CMBGetItemInfoByNoteIDReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) 
            + sizeof(m_dwAppUserID) + sizeof(m_guidNote));
}

void CMBGetItemInfoByNoteIDReq::ReleaseBuf()
{    
}

int CMBGetItemInfoByNoteIDReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidNote, sizeof(m_guidNote));
    p += sizeof(m_guidNote);
    
    return iRet;
    
}


int CMBGetItemInfoByNoteIDReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_guidNote = *((GUID*)p);
    p += sizeof(m_guidNote);
    unOffSet += sizeof(m_guidNote); 
    
    return RET_SUCCESS;
}





//CMBGetItemInfoByNoteIDAck::CMBGetItemInfoByNoteIDAck()
//{
//    m_dwConnectionID    = 0;
//    m_dwDbID            = 0;
//    m_dwAppUserID       = 0;
//    m_nRetCode          = 0;
//    m_guidNote          = GUID_NULL;
//    
//}

//CMBGetItemInfoByNoteIDAck::~CMBGetItemInfoByNoteIDAck()
//{
//    ReleaseBuf();
//}

//int CMBGetItemInfoByNoteIDAck::GetFixedLen()
//{
//    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) 
//            + sizeof(m_dwAppUserID) + sizeof(m_nRetCode) + sizeof(m_guidNote));
//}
//
//void CMBGetItemInfoByNoteIDAck::ReleaseBuf()
//{
//    std::list<CMBItemInfo *>::iterator it = m_lstPItemInfo.begin();
//    while (it != m_lstPItemInfo.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
//}
//
//int CMBGetItemInfoByNoteIDAck::Encode(char** pSend, uint32_t& unLen)
//{
//    int iRet = RET_SUCCESS;
//    
//    unLen = this->GetFixedLen() + sizeof(uint32_t);     
//    
//    //这个比较特别 用CMBItemInfo类来存储数据 但并不存储ITEM的内容 
//    //所以CMBItemInfo::m_pData = NULL 而CMBItemInfo::m_unDataLen不为0 所以不能用CMBItemInfo::GetObjSize()来取大小
//    uint32_t unAtomLen = offsetof(class CMBItemInfo, m_pData);
//    
//    unLen += unAtomLen * m_lstPItemInfo.size();
//    
//    //     std::list<CMBItemInfo *>::iterator it = m_lstPItemInfo.begin();
//    //     while (m_lstPItemInfo.end() != it)
//    //     {
//    //         if (RET_SUCCESS != (iRet = (*it)->GetObjSize(unAtomLen)))
//    //         {
//    //             return iRet;
//    //         }
//    // 
//    //         unLen += unAtomLen;
//    // 
//    //         ++it;
//    //     }
//    
//    // 申请内存块用于发送数据    
//    *pSend = new(std::nothrow) char[unLen];
//    if (NULL == *pSend)
//    {
//        return RET_MB_MSG_MEM_BAD_ALLOC;
//    }
//    
//    memset(*pSend, 0x0, unLen);
//    
//    //拼装数据
//    char *p = *pSend;
//    
//    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
//    p += sizeof(m_dwConnectionID);
//    
//    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
//    p += sizeof(m_dwDbID);    
//    
//    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
//    p += sizeof(m_dwAppUserID);
//    
//    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
//    p += sizeof(m_nRetCode);
//    
//    memcpy(p, &m_guidNote, sizeof(m_guidNote));
//    p += sizeof(m_guidNote);
//    
//    uint32_t unCnt = (uint32_t)m_lstPItemInfo.size();
//    memcpy(p, &unCnt, sizeof(unCnt));
//    p += sizeof(unCnt);    
//    
//    std::list<CMBItemInfo *>::iterator it = m_lstPItemInfo.begin();
//    while (m_lstPItemInfo.end() != it)
//    {
//        memcpy(p, (*it), unAtomLen);
//        p += unAtomLen;
//        ++it;
//    }
//    
//    return iRet;
//}
//
//
//int CMBGetItemInfoByNoteIDAck::Decode(char* pRev, uint32_t unLen)
//{
//    ReleaseBuf();
//    
//    uint32_t unMinLen = this->GetFixedLen();
//    unMinLen += sizeof(uint32_t);
//    
//    if (unLen < unMinLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    char *p = pRev;
//    
//    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
//    
//    m_dwConnectionID = *((uint32_t*)p);
//    p += sizeof(m_dwConnectionID);
//    unOffSet += sizeof(m_dwConnectionID);
//    
//    m_dwDbID = *((uint32_t*)p);
//    p += sizeof(m_dwDbID);
//    unOffSet += sizeof(m_dwDbID);
//    
//    m_dwAppUserID = *((uint32_t*)p);
//    p += sizeof(m_dwAppUserID);
//    unOffSet += sizeof(m_dwAppUserID);  
//    
//    m_nRetCode =  *((uint32_t *)p);
//    p += sizeof(m_nRetCode);
//    unOffSet += sizeof(m_nRetCode);
//    
//    m_guidNote =  *((GUID *)p);
//    p += sizeof(m_guidNote);
//    unOffSet += sizeof(m_guidNote);
//    
//    uint32_t unCnt =  *((uint32_t *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//    
//    //这个比较特别 用CMBItemInfo类来存储数据 但并不存储ITEM的内容 
//    //所以CMBItemInfo::m_pData = NULL 而CMBItemInfo::m_unDataLen不为0 
//    uint32_t unAtomLen = offsetof(class CMBItemInfo, m_pData);
//    
//    m_lstPItemInfo.clear();
//    
//    for (uint32_t i = 0; i < unCnt; i++)
//    {
//        unOffSet += unAtomLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        CMBItemInfo *pMBItemInfo = new CMBItemInfo();
//        pMBItemInfo->m_pData = NULL;
//        memcpy(pMBItemInfo, p, unAtomLen);
//        
//        p += unAtomLen;
//        
//        m_lstPItemInfo.push_back(pMBItemInfo);
//    }
//    
//    return RET_SUCCESS;
//}



//扩展接口
CMBItemInfoExReq::CMBItemInfoExReq()
{
}

CMBItemInfoExReq::~CMBItemInfoExReq()
{
    ReleaseBuf();
}

int CMBItemInfoExReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_guidItem) + sizeof(m_dwCurVer)
            + sizeof(m_unScreenx) + sizeof(m_unScreeny));
}

void CMBItemInfoExReq::ReleaseBuf()
{
    
}

int CMBItemInfoExReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidItem, sizeof(m_guidItem));
    p += sizeof(m_guidItem);   
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    memcpy(p, &m_unScreenx, sizeof(m_unScreenx));
    p += sizeof(m_unScreenx);
    
    memcpy(p, &m_unScreeny, sizeof(m_unScreeny));
    p += sizeof(m_unScreeny);
    
    return RET_SUCCESS;
}

int CMBItemInfoExReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidItem = *((GUID *)p);
    p += sizeof(m_guidItem);
    unOffSet += sizeof(m_guidItem);  
    
    m_dwCurVer = *((uint32_t *)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer);  
    
    m_unScreenx = *((uint32_t *)p);
    p += sizeof(m_unScreenx);
    unOffSet += sizeof(m_unScreenx);
    
    m_unScreeny = *((uint32_t *)p);
    p += sizeof(m_unScreeny);
    unOffSet += sizeof(m_unScreeny);
    
    return RET_SUCCESS;
    
}

//  请求
CMBItemNewReq::CMBItemNewReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    
    m_guidItem          = GUID_NULL;
    m_dwCurVer          = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
}

CMBItemNewReq::~CMBItemNewReq()
{
    ReleaseBuf();
}

int CMBItemNewReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_guidItem) + sizeof(m_dwCurVer) + sizeof(m_szReserve));
}

void CMBItemNewReq::ReleaseBuf()
{
    
}

int CMBItemNewReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidItem, sizeof(m_guidItem));
    p += sizeof(m_guidItem);   
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    return RET_SUCCESS;
}

int CMBItemNewReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidItem = *((GUID *)p);
    p += sizeof(m_guidItem);
    unOffSet += sizeof(m_guidItem);  
    
    m_dwCurVer = *((uint32_t *)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer);  
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);
    
    return RET_SUCCESS;
}







//   响应
CMBItemNewAck::CMBItemNewAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    
    m_nRetCode          = 0;
    m_guidItem          = GUID_NULL;
    m_nIsNeedDownLoad   = 0;    
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    
//    m_pItemNew = NULL;
}

CMBItemNewAck::~CMBItemNewAck()
{
    ReleaseBuf();
}

int CMBItemNewAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_nRetCode) + sizeof(m_guidItem) + sizeof(m_nIsNeedDownLoad) + sizeof(m_szReserve));
}

void CMBItemNewAck::ReleaseBuf()
{
//    if (NULL != m_pItemNew)
//    {
//        delete m_pItemNew;
//        m_pItemNew = NULL;
//    }
}

int CMBItemNewAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);
    
    uint32_t unContentSize = 0;
    uint32_t unCnt         = 0;
    
//    if (NULL != m_pItemNew)
//    {       
        if (RET_SUCCESS != (iRet = m_pItemNew.GetObjSize(unContentSize)))
        {
            // CHECK: [czc] [时间: 2009-07-28]【写日志和容错处理】
            return iRet;
        }
        
        unCnt = 1;
        
        unLen += unContentSize;
//    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);    
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    memcpy(p, &m_guidItem, sizeof(m_guidItem));
    p += sizeof(m_guidItem);
    
    memcpy(p, &m_nIsNeedDownLoad, sizeof(m_nIsNeedDownLoad));
    p += sizeof(m_nIsNeedDownLoad);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);
    
    memcpy(p, &m_pItemNew, offsetof(CMBItemNew, wszTitle));
    p += offsetof(CMBItemNew, wszTitle);
    
    if (m_pItemNew.wszTitle) {
        unsigned int titlelen = getUnicodeLength((unsigned char *)p);
        memcpy(p, m_pItemNew.wszTitle, titlelen);
        p += titlelen;
        memset(p, 0, 2);
        p += 2; 
    }
    else {
        memset(p, 0, 2);
        p += 2;
    }
    
    unsigned int len = *(unsigned int*)p;
    p += sizeof(unsigned int);
    
    if (NULL != m_pItemNew.m_pData)
    {            
        memcpy(p, m_pItemNew.m_pData, len);
    }
    
    return RET_SUCCESS;
}

int CMBItemNewAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    m_guidItem = *((GUID *)p);
    p += sizeof(m_guidItem);
    unOffSet += sizeof(m_guidItem);
    
    m_nIsNeedDownLoad = *((int *)p);
    p += sizeof(m_nIsNeedDownLoad);
    unOffSet += sizeof(m_nIsNeedDownLoad);
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);
    
    uint32_t unCnt = *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    int lensum = unOffSet + offsetof(CMBItemNew, wszTitle) + sizeof(unsigned int) + (getUnicodeLength((unsigned char *)p) + 2);
    if (lensum > unLen)
    {
        // CHECK: [czc] [时间: 2009-07-28]【写日志】
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    if (0 != unCnt)
    {
        //m_pItemNew = new CMBItemNew();
        // CHECK: [czc] [时间: 2009-07-28]【NULL == m_pItemInfo】
        //memcpy(&m_pItemNew, p, offsetof(CMBItemNew, m_pData));
        //p += offsetof(CMBItemNew, m_pData);
        memcpy(&m_pItemNew, p, offsetof(CMBItemNew, wszTitle));
        p += offsetof(CMBItemNew, wszTitle);
        unsigned int titlelen = getUnicodeLength((unsigned char *)p);
        titlelen += 2;
        if (m_pItemNew.wszTitle != NULL) {
            delete m_pItemNew.wszTitle;
        }
        m_pItemNew.wszTitle = new unsigned char[titlelen];
        memcpy(m_pItemNew.wszTitle, p, titlelen);
        p += titlelen;
        unsigned int len = *(unsigned int*)p;
        m_pItemNew.m_unDataLen = len;
        p += sizeof(unsigned int);
        
        if ((unOffSet + m_pItemNew.m_unDataLen) > unLen)
        {
            // CHECK: [czc] [时间: 2009-07-28]【写日志】
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        if (0 != m_pItemNew.m_unDataLen)
        {
            m_pItemNew.m_pData = new(std::nothrow) unsigned char[m_pItemNew.m_unDataLen];
            if (NULL == m_pItemNew.m_pData)
            {
                // CHECK: [czc] [时间: 2009-07-28]【写日志】
                return RET_MB_MSG_MEM_BAD_ALLOC;
            }            
            memcpy(m_pItemNew.m_pData, p, m_pItemNew.m_unDataLen);
            
            p += m_pItemNew.m_unDataLen;
        }        
    }
    
    return RET_SUCCESS;
    
}



// OPN_MB_GET_ITEM_NEW_EX_REQ  / OPN_MB_GET_ITEM_NEW_EX_ACK
CMBItemNewExReq::CMBItemNewExReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    
    m_guidItem          = GUID_NULL;
    
    m_dwCurVer          = 0;
    m_unScreenx         = 0;
    m_unScreeny         = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    
}

CMBItemNewExReq::~CMBItemNewExReq()
{
    ReleaseBuf();
}

int CMBItemNewExReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_guidItem) + sizeof(m_dwCurVer)
            + sizeof(m_unScreenx) + sizeof(m_unScreeny)
            + sizeof(m_szReserve));
}

void CMBItemNewExReq::ReleaseBuf()
{
    
}

int CMBItemNewExReq::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {        
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidItem, sizeof(m_guidItem));
    p += sizeof(m_guidItem);   
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    memcpy(p, &m_unScreenx, sizeof(m_unScreenx));
    p += sizeof(m_unScreenx);
    
    memcpy(p, &m_unScreeny, sizeof(m_unScreeny));
    p += sizeof(m_unScreeny);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    return RET_SUCCESS;
}

int CMBItemNewExReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {        
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidItem = *((GUID *)p);
    p += sizeof(m_guidItem);
    unOffSet += sizeof(m_guidItem);  
    
    m_dwCurVer = *((uint32_t *)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer);  
    
    m_unScreenx = *((uint32_t *)p);
    p += sizeof(m_unScreenx);
    unOffSet += sizeof(m_unScreenx);
    
    m_unScreeny = *((uint32_t *)p);
    p += sizeof(m_unScreeny);
    unOffSet += sizeof(m_unScreeny);
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);
    
    
    return RET_SUCCESS;
    
}

CMBNoteListReq::CMBNoteListReq()
{
    
}

CMBNoteListReq::~CMBNoteListReq()
{
    ReleaseBuf();
}

int CMBNoteListReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_guidDir) + sizeof(m_dwVerFrom));
}

void CMBNoteListReq::ReleaseBuf()
{    
}

int CMBNoteListReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidDir, sizeof(m_guidDir));
    p += sizeof(m_guidDir);
    
    memcpy(p, &m_dwVerFrom, sizeof(m_dwVerFrom));
    p += sizeof(m_dwVerFrom);
    
    return iRet;
    
}


int CMBNoteListReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidDir =  *((GUID *)p);
    p += sizeof(m_guidDir);
    unOffSet += sizeof(m_guidDir);  
    
    m_dwVerFrom = *((uint32_t*)p);
    p += sizeof(m_dwVerFrom);
    unOffSet += sizeof(m_dwVerFrom); 
    
    return RET_SUCCESS;
}






//CMBNoteListAck::CMBNoteListAck()
//{
//    
//}
//
//CMBNoteListAck::~CMBNoteListAck()
//{
//    ReleaseBuf();
//}
//
//int CMBNoteListAck::GetFixedLen()
//{
//    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
//}
//
//void CMBNoteListAck::ReleaseBuf()
//{
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (it != m_lstPMBNoteInfo.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
//}
//
//int CMBNoteListAck::Encode(char** pSend, uint32_t& unLen)
//{
//    int iRet = RET_SUCCESS;
//    
//    unLen = this->GetFixedLen() + sizeof(uint32_t);     
//    
//    uint32_t unAtomLen = 0;
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        if (RET_SUCCESS != (iRet = (*it)->GetObjSize(unAtomLen)))
//        {
//            return iRet;
//        }
//        
//        unLen += unAtomLen;
//        
//        ++it;
//    }
//    
//    // 申请内存块用于发送数据    
//    *pSend = new(std::nothrow) char[unLen];
//    if (NULL == *pSend)
//    {
//        return RET_MB_MSG_MEM_BAD_ALLOC;
//    }
//    
//    memset(*pSend, 0x0, unLen);
//    
//    //拼装数据
//    char *p = *pSend;
//    
//    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
//    p += sizeof(m_dwConnectionID);
//    
//    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
//    p += sizeof(m_dwDbID);    
//    
//    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
//    p += sizeof(m_dwAppUserID);
//    
//    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
//    p += sizeof(m_nRetCode);
//    
//    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfo.size();
//    memcpy(p, &unCnt, sizeof(unCnt));
//    p += sizeof(unCnt);    
//    
//    it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        memcpy(p, (*it), offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
//        
//        ++it;
//    }
//    
//    return RET_SUCCESS;
//}
//
//
//int CMBNoteListAck::Decode(char* pRev, uint32_t unLen)
//{
//    ReleaseBuf();
//    
//    uint32_t unMinLen = this->GetFixedLen();
//    unMinLen += sizeof(uint32_t);
//    
//    if (unLen < unMinLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    char *p = pRev;
//    
//    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
//    
//    m_dwConnectionID = *((uint32_t*)p);
//    p += sizeof(m_dwConnectionID);
//    unOffSet += sizeof(m_dwConnectionID);
//    
//    m_dwDbID = *((uint32_t*)p);
//    p += sizeof(m_dwDbID);
//    unOffSet += sizeof(m_dwDbID);
//    
//    m_dwAppUserID = *((uint32_t*)p);
//    p += sizeof(m_dwAppUserID);
//    unOffSet += sizeof(m_dwAppUserID);  
//    
//    m_nRetCode =  *((uint32_t *)p);
//    p += sizeof(m_nRetCode);
//    unOffSet += sizeof(m_nRetCode);
//    
//    uint32_t unCnt =  *((uint32_t *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//    
//    m_lstPMBNoteInfo.clear();
//    
//    for (uint32_t i = 0; i < unCnt; i++)
//    {
//        unOffSet += offsetof(CMBNoteInfo, pwszTitle);
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        
//        CMBNoteInfo *pMBNoteInfo = new CMBNoteInfo();
//        memcpy(pMBNoteInfo, p, offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszTitle, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszAddr, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszSrc, p, unStrLen);
//        
//        p += unStrLen;
//        
//        
//        m_lstPMBNoteInfo.push_back(pMBNoteInfo);
//    }
//    
//    return RET_SUCCESS;
//}



//扩展接口

CMBNoteListExReq::CMBNoteListExReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_guidDir           = GUID_NULL;
    m_dwVerFrom         = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
}

CMBNoteListExReq::~CMBNoteListExReq()
{
    ReleaseBuf();
}

int CMBNoteListExReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_guidDir) + sizeof(m_dwVerFrom) + sizeof(m_szReserve));
}

void CMBNoteListExReq::ReleaseBuf()
{    
}

int CMBNoteListExReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidDir, sizeof(m_guidDir));
    p += sizeof(m_guidDir);
    
    memcpy(p, &m_dwVerFrom, sizeof(m_dwVerFrom));
    p += sizeof(m_dwVerFrom);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    return iRet;
    
}


int CMBNoteListExReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidDir =  *((GUID *)p);
    p += sizeof(m_guidDir);
    unOffSet += sizeof(m_guidDir);  
    
    m_dwVerFrom = *((uint32_t*)p);
    p += sizeof(m_dwVerFrom);
    unOffSet += sizeof(m_dwVerFrom); 
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve); 
    
    return RET_SUCCESS;
}






CMBNoteListExAck::CMBNoteListExAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_nRetCode          = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    m_lstPMBNoteInfoEx.clear();
    
}

CMBNoteListExAck::~CMBNoteListExAck()
{
    ReleaseBuf();
}

int CMBNoteListExAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_nRetCode) + sizeof(m_szReserve));
}

void CMBNoteListExAck::ReleaseBuf()
{
//    std::list<NoteInfo *>::iterator it = m_lstPMBNoteInfoEx.begin();
//    while (it != m_lstPMBNoteInfoEx.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
    
    m_lstPMBNoteInfoEx.clear();
}

int CMBNoteListExAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<NoteInfo>::iterator it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfoEx.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        memcpy(p, &(*it), offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        wcscpy_m(p, (char*)(*it).strTitle.c_str());
        p += ((*it).strTitle.length() + 1) * 2;
        
        wcscpy_m(p, (char*)(*it).strAddr.c_str());
        p += ((*it).strAddr.length() + 1) * 2;
        
        wcscpy_m(p, (char*)(*it).strSrc.c_str());
        p += ((*it).strSrc.length() + 1) * 2;
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
        
        ++it;
    }
    
    return RET_SUCCESS;
}


int CMBNoteListExAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode =  *((uint32_t *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPMBNoteInfoEx.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(NoteInfo, strTitle);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        NoteInfo pMBNoteInfoEx;
        memcpy(&pMBNoteInfoEx, p, offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszTitle, p, unStrLen);
        pMBNoteInfoEx.strTitle = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszAddr, p, unStrLen);
        pMBNoteInfoEx.strAddr = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszSrc, p, unStrLen);
        pMBNoteInfoEx.strSrc = (unichar*)p;
        
        p += unStrLen;
        
        m_lstPMBNoteInfoEx.push_back(pMBNoteInfoEx);
    }
    
    return RET_SUCCESS;
}

CMBNoteThumbReq::CMBNoteThumbReq()
{
    m_dwConnectionID    = 0;	//链路ID                                       
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0 
    m_dwAppUserID       = 0;      //本次查询数据的用户ID                       
    m_guidNote          = GUID_NULL;                                                      
    m_dwCurVer          = 0;         //暂留                                       
    m_unWidth           = 0;// 宽度                                      
    m_unHeight          = 0;// 高度                                      
    
}

CMBNoteThumbReq::~CMBNoteThumbReq()
{
    ReleaseBuf();
}

int CMBNoteThumbReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_guidNote) + sizeof(m_dwCurVer) + sizeof(m_unWidth) + sizeof(m_unHeight));
}

void CMBNoteThumbReq::ReleaseBuf()
{    
}

int CMBNoteThumbReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_guidNote, sizeof(m_guidNote));
    p += sizeof(m_guidNote);
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    memcpy(p, &m_unWidth, sizeof(m_unWidth));
    p += sizeof(m_unWidth);
    
    memcpy(p, &m_unHeight, sizeof(m_unHeight));
    p += sizeof(m_unHeight);
    
    return iRet;
    
}


int CMBNoteThumbReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_guidNote =  *((GUID *)p);
    p += sizeof(m_guidNote);
    unOffSet += sizeof(m_guidNote);  
    
    m_dwCurVer = *((uint32_t*)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer); 
    
    m_unWidth = *((uint32_t*)p);
    p += sizeof(m_unWidth);
    unOffSet += sizeof(m_unWidth);
    
    m_unHeight = *((uint32_t*)p);
    p += sizeof(m_unHeight);
    unOffSet += sizeof(m_unHeight);
    
    return RET_SUCCESS;
}





CMBNoteThumbAck::CMBNoteThumbAck()
{
    m_dwConnectionID    = 0;	//链路ID                                       
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0 
    m_dwAppUserID       = 0;      //本次查询数据的用户ID  
    
    m_nRetCode          = 0;
    m_guidNote          = GUID_NULL;                                                      
    m_dwCurVer          = 0;         //暂留        
    
    m_unDataLen         = 0;                        
    m_pData             = NULL;            
    
}

CMBNoteThumbAck::~CMBNoteThumbAck()
{
    ReleaseBuf();
}

int CMBNoteThumbAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_nRetCode) + sizeof(m_guidNote) + sizeof(m_dwCurVer) + sizeof(m_unDataLen));
}

void CMBNoteThumbAck::ReleaseBuf()
{
    if (NULL != m_pData)
    {
        delete[] m_pData;
        m_pData = NULL;
    }
    
    m_unDataLen = 0;
}

int CMBNoteThumbAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    unLen += m_unDataLen;
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    memcpy(p, &m_guidNote, sizeof(m_guidNote));
    p += sizeof(m_guidNote);
    
    memcpy(p, &m_dwCurVer, sizeof(m_dwCurVer));
    p += sizeof(m_dwCurVer);
    
    memcpy(p, &m_unDataLen, sizeof(m_unDataLen));
    p += sizeof(m_unDataLen);
    
    if ((0 != m_unDataLen) && (NULL != m_pData))
    {
        memcpy(p, m_pData, m_unDataLen);
        p += m_unDataLen;
    }   
    
    return iRet;
    
}


int CMBNoteThumbAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_nRetCode = *((int*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    m_guidNote =  *((GUID *)p);
    p += sizeof(m_guidNote);
    unOffSet += sizeof(m_guidNote);  
    
    m_dwCurVer = *((uint32_t*)p);
    p += sizeof(m_dwCurVer);
    unOffSet += sizeof(m_dwCurVer); 
    
    m_unDataLen = *((uint32_t*)p);
    p += sizeof(m_unDataLen);
    unOffSet += sizeof(m_unDataLen);
    
    if ((unOffSet + m_unDataLen) > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    if (0 != m_unDataLen)
    {
        // 申请内存块用于发送数据    
        m_pData = new(std::nothrow) unsigned char[m_unDataLen];
        if (NULL == m_pData)
        {
            return RET_MB_MSG_MEM_BAD_ALLOC;
        }        
        
        memcpy(m_pData, p, m_unDataLen);
        
        unOffSet += m_unDataLen;
    }
    
    return RET_SUCCESS;
}


CMBSearchNoteReq::CMBSearchNoteReq()
{
    m_dwConnectionID    = 0;	//链路ID                                       
    m_dwDbID            = 0;           //本次数据所有者的用户ID 如果是公共数据则为0 
    m_dwAppUserID       = 0;      //本次查询数据的用户ID    
    
    m_unLimitCnt        = 0;
    m_unOrderType       = 0;
    
    m_pwszTimeStart     = NULL;
    m_pwszTimeEnd       = NULL;
    m_pwszKeyWord       = NULL;
    
}

CMBSearchNoteReq::~CMBSearchNoteReq()
{
    ReleaseBuf();
}

int CMBSearchNoteReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID)
            + sizeof(m_unLimitCnt) + sizeof(m_unOrderType));
}

void CMBSearchNoteReq::ReleaseBuf()
{
    if (NULL != m_pwszTimeStart)
    {
        delete[] m_pwszTimeStart;
        m_pwszTimeStart =NULL;
    }
    
    if (NULL != m_pwszTimeEnd)
    {
        delete[] m_pwszTimeEnd;
        m_pwszTimeEnd =NULL;
    }
    
    if (NULL != m_pwszKeyWord)
    {
        delete[] m_pwszKeyWord;
        m_pwszKeyWord =NULL;
    }
}

int CMBSearchNoteReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    if (NULL == m_pwszKeyWord)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    //先算m_pwszKeyWord的大小
    uint32_t unStrLen = (wcslen_m((char*)m_pwszKeyWord) + 1) * 2;
    
    unLen += unStrLen;
    
    //再算m_pwszTimeStart 和 m_pwszTimeEnd的内存大小
    unLen += 2 * sizeof(uint32_t);//这两个uint32_t用来记录 m_pwszTimeStart 和 m_pwszTimeEnd的内存大小 为0 则表示是空
    uint32_t unTimeStart    = 0;
    uint32_t unTimeEnd      = 0;
    if (NULL != m_pwszTimeStart)
    {
        unTimeStart = (wcslen_m((char*)m_pwszTimeStart) + 1) * 2;
    }
    if (NULL != m_pwszTimeEnd)
    {
        unTimeEnd = (wcslen_m((char*)m_pwszTimeEnd) + 1) * 2;
    }
    
    unLen += unTimeStart + unTimeEnd;
    
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_unLimitCnt, sizeof(m_unLimitCnt));
    p += sizeof(m_unLimitCnt);
    
    memcpy(p, &m_unOrderType, sizeof(m_unOrderType));
    p += sizeof(m_unOrderType);
    
    memcpy(p, &unTimeStart, sizeof(unTimeStart));
    p += sizeof(unTimeStart);
    
    if (0 != unTimeStart)
    {
        memcpy(p, m_pwszTimeStart, unTimeStart);
        p += unTimeStart;
    }
    
    memcpy(p, &unTimeEnd, sizeof(unTimeEnd));
    p += sizeof(unTimeEnd);
    
    if (0 != m_pwszTimeEnd)
    {
        memcpy(p, m_pwszTimeEnd, unTimeEnd);
        p += unTimeEnd;
    }
    
    wcscpy_m(p, (char*)m_pwszKeyWord);
    
    return iRet;
    
}


int CMBSearchNoteReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    unMinLen += 2 * sizeof(uint32_t) + 2;
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    
    m_unLimitCnt = *((uint32_t*)p);
    p += sizeof(m_unLimitCnt);
    unOffSet += sizeof(m_unLimitCnt);
    
    m_unOrderType = *((uint32_t*)p);
    p += sizeof(m_unOrderType);
    unOffSet += sizeof(m_unOrderType);
    
    uint32_t unTimeStart    = 0;
    uint32_t unTimeEnd      = 0;
    
    unTimeStart = *((uint32_t*)p);
    p += sizeof(unTimeStart);
    unOffSet += sizeof(unTimeStart);
    
    unOffSet += unTimeStart;
    if (unOffSet > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    if (0 != unTimeStart)
    {
        m_pwszTimeStart = new unichar[unTimeStart / 2];        
        memcpy(m_pwszTimeStart, p, unTimeStart);
        
        p += unTimeStart;
    }
    
    
    unTimeEnd = *((uint32_t*)p);
    p += sizeof(unTimeEnd);
    unOffSet += sizeof(unTimeEnd);
    
    unOffSet += unTimeEnd;
    if (unOffSet > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    if (0 != unTimeEnd)
    {
        m_pwszTimeEnd = new unichar[unTimeEnd / 2];        
        memcpy(m_pwszTimeEnd, p, unTimeEnd);
        
        p += unTimeEnd;
    }
    
    uint32_t unStrLen = (wcslen_m(p) + 1) * 2;    
    unOffSet += unStrLen;
    if (unOffSet > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    m_pwszKeyWord = new unichar[unStrLen / 2];//已经把"\0"算进去了
    memcpy((void*)m_pwszKeyWord, (void*)p, unStrLen);    
    
    return RET_SUCCESS;
}





//CMBSearchNoteAck::CMBSearchNoteAck()
//{
//    
//}
//
//CMBSearchNoteAck::~CMBSearchNoteAck()
//{
//    ReleaseBuf();
//}
//
//int CMBSearchNoteAck::GetFixedLen()
//{
//    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
//            + sizeof(m_nRetCode) + sizeof(m_unTotalCnt));
//}
//
//void CMBSearchNoteAck::ReleaseBuf()
//{
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (it != m_lstPMBNoteInfo.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
//}
//
//int CMBSearchNoteAck::Encode(char** pSend, uint32_t& unLen)
//{
//    int iRet = RET_SUCCESS;
//    
//    unLen = this->GetFixedLen() + sizeof(uint32_t);     
//    
//    uint32_t unAtomLen = 0;
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        if (RET_SUCCESS != (iRet = (*it)->GetObjSize(unAtomLen)))
//        {
//            return iRet;
//        }
//        
//        unLen += unAtomLen;
//        
//        ++it;
//    }
//    
//    // 申请内存块用于发送数据    
//    *pSend = new(std::nothrow) char[unLen];
//    if (NULL == *pSend)
//    {
//        return RET_MB_MSG_MEM_BAD_ALLOC;
//    }
//    
//    memset(*pSend, 0x0, unLen);
//    
//    //拼装数据
//    char *p = *pSend;
//    
//    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
//    p += sizeof(m_dwConnectionID);
//    
//    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
//    p += sizeof(m_dwDbID);    
//    
//    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
//    p += sizeof(m_dwAppUserID);
//    
//    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
//    p += sizeof(m_nRetCode);
//    
//    memcpy(p, &m_unTotalCnt, sizeof(m_unTotalCnt));
//    p += sizeof(m_unTotalCnt);
//    
//    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfo.size();
//    memcpy(p, &unCnt, sizeof(unCnt));
//    p += sizeof(unCnt);    
//    
//    it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        memcpy(p, (*it), offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
//        
//        ++it;
//    }
//    
//    return RET_SUCCESS;
//}
//
//
//int CMBSearchNoteAck::Decode(char* pRev, uint32_t unLen)
//{
//    ReleaseBuf();
//    
//    uint32_t unMinLen = this->GetFixedLen();
//    unMinLen += sizeof(uint32_t);
//    
//    if (unLen < unMinLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    char *p = pRev;
//    
//    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
//    
//    m_dwConnectionID = *((uint32_t*)p);
//    p += sizeof(m_dwConnectionID);
//    unOffSet += sizeof(m_dwConnectionID);
//    
//    m_dwDbID = *((uint32_t*)p);
//    p += sizeof(m_dwDbID);
//    unOffSet += sizeof(m_dwDbID);
//    
//    m_dwAppUserID = *((uint32_t*)p);
//    p += sizeof(m_dwAppUserID);
//    unOffSet += sizeof(m_dwAppUserID);  
//    
//    m_nRetCode =  *((uint32_t *)p);
//    p += sizeof(m_nRetCode);
//    unOffSet += sizeof(m_nRetCode);
//    
//    m_unTotalCnt =  *((uint32_t *)p);
//    p += sizeof(m_unTotalCnt);
//    unOffSet += sizeof(m_unTotalCnt);
//    
//    uint32_t unCnt =  *((uint32_t *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//    
//    m_lstPMBNoteInfo.clear();
//    
//    for (uint32_t i = 0; i < unCnt; i++)
//    {
//        unOffSet += offsetof(CMBNoteInfo, pwszTitle);
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        
//        CMBNoteInfo *pMBNoteInfo = new CMBNoteInfo();
//        memcpy(pMBNoteInfo, p, offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszTitle, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszAddr, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszSrc, p, unStrLen);
//        
//        p += unStrLen;
//        
//        
//        m_lstPMBNoteInfo.push_back(pMBNoteInfo);
//    }
//    
//    return RET_SUCCESS;
//}



//扩展接口
CMBSearchNoteExAck::CMBSearchNoteExAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_nRetCode          = 0;
    m_unTotalCnt        = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    
    m_lstPMBNoteInfoEx.clear();
}

CMBSearchNoteExAck::~CMBSearchNoteExAck()
{
    ReleaseBuf();
}

int CMBSearchNoteExAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_nRetCode) + sizeof(m_unTotalCnt) + sizeof(m_szReserve));
}

void CMBSearchNoteExAck::ReleaseBuf()
{
//    std::list<CMBNoteInfoEx>::iterator it = m_lstPMBNoteInfoEx.begin();
//    while (it != m_lstPMBNoteInfoEx.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
    m_lstPMBNoteInfoEx.clear();
}

int CMBSearchNoteExAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<NoteInfo>::iterator it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    memcpy(p, &m_unTotalCnt, sizeof(m_unTotalCnt));
    p += sizeof(m_unTotalCnt);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfoEx.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        memcpy(p, &(*it), offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        wcscpy_m(p, (char*)(*it).strTitle.c_str());
        p += ((*it).strTitle.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strAddr.c_str());
        p += ((*it).strAddr.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strSrc.c_str());
        p += ((*it).strSrc.length() + 1) * 2;
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
        
        ++it;
    }
    
    return RET_SUCCESS;
}


int CMBSearchNoteExAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode =  *((uint32_t *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    m_unTotalCnt =  *((uint32_t *)p);
    p += sizeof(m_unTotalCnt);
    unOffSet += sizeof(m_unTotalCnt);
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPMBNoteInfoEx.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(NoteInfo, strTitle);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        NoteInfo pMBNoteInfoEx;
        memcpy(&pMBNoteInfoEx, p, offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszTitle, p, unStrLen);
        pMBNoteInfoEx.strTitle = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszAddr, p, unStrLen);
        pMBNoteInfoEx.strAddr = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszSrc, p, unStrLen);
        pMBNoteInfoEx.strSrc = (unichar*)p;
        
        p += unStrLen;
        
        m_lstPMBNoteInfoEx.push_back(pMBNoteInfoEx);
    }
    
    return RET_SUCCESS;
}

CMBShareByCataListReq::CMBShareByCataListReq()
{
    
}

CMBShareByCataListReq::~CMBShareByCataListReq()
{
    ReleaseBuf();
}

int CMBShareByCataListReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_dwVerFrom));
}

void CMBShareByCataListReq::ReleaseBuf()
{    
}

int CMBShareByCataListReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen();
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_dwVerFrom, sizeof(m_dwVerFrom));
    p += sizeof(m_dwVerFrom);
    
    return iRet;
    
}


int CMBShareByCataListReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_dwVerFrom = *((uint32_t*)p);
    p += sizeof(m_dwVerFrom);
    unOffSet += sizeof(m_dwVerFrom); 
    
    return RET_SUCCESS;
}






CMBShareByCataListAck::CMBShareByCataListAck()
{
    
}

CMBShareByCataListAck::~CMBShareByCataListAck()
{
    ReleaseBuf();
}

int CMBShareByCataListAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBShareByCataListAck::ReleaseBuf()
{
//    std::list<CMBShareInfo *>::iterator it = m_lstPMBShareInfo.begin();
//    while (it != m_lstPMBShareInfo.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
}

int CMBShareByCataListAck::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<CMBShareInfo>::iterator it = m_lstPMBShareInfo.begin();
    while (m_lstPMBShareInfo.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    uint32_t unCnt = (uint32_t)m_lstPMBShareInfo.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPMBShareInfo.begin();
    while (m_lstPMBShareInfo.end() != it)
    {
        memcpy(p, &(*it), sizeof(CMBShareInfo));
        p += sizeof(CMBShareInfo);
        
        ++it;
    }
    
    return RET_SUCCESS;
}


int CMBShareByCataListAck::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode =  *((uint32_t *)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPMBShareInfo.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CMBShareInfo);        
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CMBShareInfo pMBShareInfo;
        memcpy(&pMBShareInfo, p, sizeof(CMBShareInfo));
        p += sizeof(CMBShareInfo);
        
        m_lstPMBShareInfo.push_back(pMBShareInfo);
    }
    
    return RET_SUCCESS;
}

//  请求
CMBUpLoadA2BInfoReq::CMBUpLoadA2BInfoReq()
{
}

CMBUpLoadA2BInfoReq::~CMBUpLoadA2BInfoReq()
{
    ReleaseBuf();
}

int CMBUpLoadA2BInfoReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID));
}

void CMBUpLoadA2BInfoReq::ReleaseBuf()
{
//    std::list<CMBA2BInfo>::iterator it = m_lstPA2BInfo.begin();
//    while (m_lstPA2BInfo.end() != it)
//    {
//        delete (*it);
//        (*it) = NULL;
//        ++it;
//    }
}

int CMBUpLoadA2BInfoReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);    
    
    uint32_t unAtomLen = 0;
    std::list<CMBA2BInfo>::iterator it = m_lstPA2BInfo.begin();
    while (m_lstPA2BInfo.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    uint32_t unCnt = (uint32_t)m_lstPA2BInfo.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPA2BInfo.begin();
    while (m_lstPA2BInfo.end() != it)
    {
        memcpy(p, &(*it), sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);
        
        ++it;
    }
    
    return RET_SUCCESS;
}

int CMBUpLoadA2BInfoReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPA2BInfo.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += sizeof(CMBA2BInfo);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        CMBA2BInfo pMBA2BInfo;
        memcpy(&pMBA2BInfo, p, sizeof(CMBA2BInfo));
        p += sizeof(CMBA2BInfo);      
        
        m_lstPA2BInfo.push_back(pMBA2BInfo);
    }
    
    return RET_SUCCESS;
    
}

//CMBUpLoadItemReq::CMBUpLoadItemReq()
//{
//    m_pItemInfo = NULL;
//}
//
//CMBUpLoadItemReq::~CMBUpLoadItemReq()
//{
//    ReleaseBuf();
//}
//
//int CMBUpLoadItemReq::GetFixedLen()
//{
//    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID));
//}
//
//void CMBUpLoadItemReq::ReleaseBuf()
//{
//    if (NULL != m_pItemInfo)
//    {
//        delete m_pItemInfo;
//        m_pItemInfo = NULL;
//    }
//}
//
//int CMBUpLoadItemReq::Encode(char** pSend, uint32_t& unLen)
//{
//    int iRet = RET_SUCCESS;
//    
//    unLen = this->GetFixedLen() + sizeof(uint32_t);
//    
//    uint32_t unContentSize = 0;
//    uint32_t unCnt         = 0;
//    
//    if (NULL != m_pItemInfo)
//    {       
//        if (RET_SUCCESS != (iRet = m_pItemInfo->GetObjSize(unContentSize)))
//        {
//            return iRet;
//        }
//        
//        unLen += unContentSize;
//        unCnt = 1;
//    }
//    
//    // 申请内存块用于发送数据    
//    *pSend = new(std::nothrow) char[unLen];
//    if (NULL == *pSend)
//    {
//        return RET_MB_MSG_MEM_BAD_ALLOC;
//    }
//    
//    memset(*pSend, 0x0, unLen);
//    
//    //拼装数据
//    char *p = *pSend;
//    
//    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
//    p += sizeof(m_dwConnectionID);
//    
//    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
//    p += sizeof(m_dwDbID);    
//    
//    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
//    p += sizeof(m_dwAppUserID);    
//    
//    memcpy(p, &unCnt, sizeof(unCnt));
//    p += sizeof(unCnt);
//    
//    if (NULL != m_pItemInfo)
//    {
//        memcpy(p, m_pItemInfo, offsetof(CMBItemInfo, m_pData));
//        p += offsetof(CMBItemInfo, m_pData);
//        
//        memcpy(p, m_pItemInfo->m_pData, m_pItemInfo->m_unDataLen);
//        p += m_pItemInfo->m_unDataLen;
//    }
//    
//    return RET_SUCCESS;
//}
//
//int CMBUpLoadItemReq::Decode(char* pRev, uint32_t unLen)
//{
//    ReleaseBuf();
//    
//    uint32_t unMinLen = this->GetFixedLen();
//    
//    if (unLen < unMinLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    char *p = pRev;
//    
//    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
//    
//    m_dwConnectionID = *((uint32_t*)p);
//    p += sizeof(m_dwConnectionID);
//    unOffSet += sizeof(m_dwConnectionID);
//    
//    m_dwDbID = *((uint32_t*)p);
//    p += sizeof(m_dwDbID);
//    unOffSet += sizeof(m_dwDbID);
//    
//    m_dwAppUserID = *((uint32_t*)p);
//    p += sizeof(m_dwAppUserID);
//    unOffSet += sizeof(m_dwAppUserID);  
//    
//    uint32_t unCnt = *((uint32_t *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//    
//    if ((unOffSet + offsetof(CMBItemInfo, m_pData)) > unLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    
//    if (0 != unCnt)
//    {
//        m_pItemInfo = new CMBItemInfo();
//        memcpy(m_pItemInfo, p, offsetof(CMBItemInfo, m_pData));
//        p += offsetof(CMBItemInfo, m_pData);
//        
//        if ((unOffSet + m_pItemInfo->m_unDataLen) > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        
//        if (0 != m_pItemInfo->m_unDataLen)
//        {
//            m_pItemInfo->m_pData = new (std::nothrow) unsigned char[m_pItemInfo->m_unDataLen];
//            if (NULL == m_pItemInfo->m_pData)
//            {
//                return RET_MB_MSG_MEM_BAD_ALLOC;
//            }
//            memcpy(m_pItemInfo->m_pData, p, m_pItemInfo->m_unDataLen);
//            
//            p += m_pItemInfo->m_unDataLen;
//        }
//    }
//    
//    return RET_SUCCESS;
//    
//}


CMBUpLoadItemNewReq::CMBUpLoadItemNewReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    
//    m_pItemNew = NULL;
    
}

CMBUpLoadItemNewReq::~CMBUpLoadItemNewReq()
{
    ReleaseBuf();
}

int CMBUpLoadItemNewReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) 
            + sizeof(m_dwAppUserID) + sizeof(m_szReserve));
}

void CMBUpLoadItemNewReq::ReleaseBuf()
{
//    if (NULL != m_pItemNew)
//    {
//        delete m_pItemNew;
//        m_pItemNew = NULL;
//    }
}

int CMBUpLoadItemNewReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);
    
    uint32_t unContentSize = 0;
    uint32_t unCnt         = 0;
    
//    if (NULL != m_pItemNew)
//    {       
        if (RET_SUCCESS != (iRet = m_pItemNew.GetObjSize(unContentSize)))
        {
            return iRet;
        }
        
        unLen += unContentSize;
        unCnt = 1;
//    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID); 
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);
    
    memcpy(p, &m_pItemNew, offsetof(CMBItemNew, wszTitle));
    p += offsetof(CMBItemNew, wszTitle);
    if (m_pItemNew.wszTitle != NULL) {
        unsigned int titlelen = getUnicodeLength((unsigned char *)m_pItemNew.wszTitle);
        memcpy(p, m_pItemNew.wszTitle, titlelen);
        p += titlelen;
        memset(p, 0, 2);
        p += 2;
    }
    else {
        memset(p, 0, 2);
        p += 2;
    }
    *(unsigned int*)p = m_pItemNew.m_unDataLen;
    p += sizeof(unsigned int);
    
    memcpy(p, m_pItemNew.m_pData, m_pItemNew.m_unDataLen);
    p += m_pItemNew.m_unDataLen;

    
    return RET_SUCCESS;
}

int CMBUpLoadItemNewReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve);  
    
    uint32_t unCnt = *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    int lensum = unOffSet + offsetof(CMBItemNew, wszTitle) + sizeof(unsigned int) + (getUnicodeLength((unsigned char *)p) + 2);
    if (lensum > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    
    if (0 != unCnt)
    {
//        m_pItemNew = new CMBItemNew();
        //memcpy(&m_pItemNew, p, offsetof(CMBItemNew, m_pData));
        //p += offsetof(CMBItemNew, m_pData);
        memcpy(&m_pItemNew, p, offsetof(CMBItemNew, wszTitle));
        p += offsetof(CMBItemNew, wszTitle);
        unsigned int titlelen = getUnicodeLength((unsigned char *)p);
        titlelen += 2;
        if (m_pItemNew.wszTitle != NULL) {
            delete m_pItemNew.wszTitle;
        }
        m_pItemNew.wszTitle = new unsigned char[titlelen];
        memcpy(m_pItemNew.wszTitle, p, titlelen);
        p += titlelen;
        unsigned int len = *(unsigned int*)p;
        m_pItemNew.m_unDataLen = len;
        p += sizeof(unsigned int);
        
        
        //if ((unOffSet + m_pItemNew.m_unDataLen) > unLen)
        //{
        //    return RET_MB_MSG_ERR_LENGTH;
        //}
        
        if (0 != m_pItemNew.m_unDataLen)
        {
            m_pItemNew.m_pData = new (std::nothrow) unsigned char[m_pItemNew.m_unDataLen];
            if (NULL == m_pItemNew.m_pData)
            {
                return RET_MB_MSG_MEM_BAD_ALLOC;
            }
            memcpy(m_pItemNew.m_pData, p, m_pItemNew.m_unDataLen);
            
            p += m_pItemNew.m_unDataLen;
        }
    }
    
    return RET_SUCCESS;
    
}

//CMBUpLoadNoteReq::CMBUpLoadNoteReq()
//{
//    
//}
//
//CMBUpLoadNoteReq::~CMBUpLoadNoteReq()
//{
//    ReleaseBuf();
//}
//
//int CMBUpLoadNoteReq::GetFixedLen()
//{
//    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID));
//}
//
//void CMBUpLoadNoteReq::ReleaseBuf()
//{
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (it != m_lstPMBNoteInfo.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
//}
//
//int CMBUpLoadNoteReq::Encode(char** pSend, uint32_t& unLen)
//{
//    int iRet = RET_SUCCESS;
//    
//    unLen = this->GetFixedLen() + sizeof(uint32_t);     
//    
//    uint32_t unAtomLen = 0;
//    std::list<CMBNoteInfo *>::iterator it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        if (RET_SUCCESS != (iRet = (*it)->GetObjSize(unAtomLen)))
//        {
//            return iRet;
//        }
//        
//        unLen += unAtomLen;
//        
//        ++it;
//    }
//    
//    // 申请内存块用于发送数据    
//    *pSend = new(std::nothrow) char[unLen];
//    if (NULL == *pSend)
//    {
//        return RET_MB_MSG_MEM_BAD_ALLOC;
//    }
//    
//    memset(*pSend, 0x0, unLen);
//    
//    //拼装数据
//    char *p = *pSend;
//    
//    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
//    p += sizeof(m_dwConnectionID);
//    
//    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
//    p += sizeof(m_dwDbID);    
//    
//    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
//    p += sizeof(m_dwAppUserID);
//    
//    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfo.size();
//    memcpy(p, &unCnt, sizeof(unCnt));
//    p += sizeof(unCnt);    
//    
//    it = m_lstPMBNoteInfo.begin();
//    while (m_lstPMBNoteInfo.end() != it)
//    {
//        memcpy(p, (*it), offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
//        
//        ++it;
//    }
//    
//    return RET_SUCCESS;
//    
//}
//
//
//int CMBUpLoadNoteReq::Decode(char* pRev, uint32_t unLen)
//{
//    ReleaseBuf();
//    
//    uint32_t unMinLen = this->GetFixedLen();
//    unMinLen += sizeof(uint32_t);
//    
//    if (unLen < unMinLen)
//    {
//        return RET_MB_MSG_ERR_LENGTH;
//    }
//    
//    char *p = pRev;
//    
//    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
//    
//    m_dwConnectionID = *((uint32_t*)p);
//    p += sizeof(m_dwConnectionID);
//    unOffSet += sizeof(m_dwConnectionID);
//    
//    m_dwDbID = *((uint32_t*)p);
//    p += sizeof(m_dwDbID);
//    unOffSet += sizeof(m_dwDbID);
//    
//    m_dwAppUserID = *((uint32_t*)p);
//    p += sizeof(m_dwAppUserID);
//    unOffSet += sizeof(m_dwAppUserID);  
//    
//    uint32_t unCnt =  *((uint32_t *)p);
//    p += sizeof(unCnt);
//    unOffSet += sizeof(unCnt);
//    
//    m_lstPMBNoteInfo.clear();
//    
//    for (uint32_t i = 0; i < unCnt; i++)
//    {
//        unOffSet += offsetof(CMBNoteInfo, pwszTitle);
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        
//        CMBNoteInfo *pMBNoteInfo = new CMBNoteInfo();
//        memcpy(pMBNoteInfo, p, offsetof(CMBNoteInfo, pwszTitle));
//        p += offsetof(CMBNoteInfo, pwszTitle);
//        
//        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszTitle, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszAddr, p, unStrLen);
//        
//        p += unStrLen;
//        
//        unStrLen = (wcslen_m(p) + 1) * 2;
//        unOffSet += unStrLen;
//        if (unOffSet > unLen)
//        {
//            return RET_MB_MSG_ERR_LENGTH;
//        }
//        pMBNoteInfo->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfo->pwszSrc, p, unStrLen);
//        
//        p += unStrLen;
//        
//        m_lstPMBNoteInfo.push_back(pMBNoteInfo);
//    }
//    
//    return RET_SUCCESS;
//}




//扩展接口
CMBUpLoadNoteExReq::CMBUpLoadNoteExReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    
    memset(m_szReserve, 0x0, sizeof(m_szReserve));
    
    m_lstPMBNoteInfoEx.clear();
}

CMBUpLoadNoteExReq::~CMBUpLoadNoteExReq()
{
    ReleaseBuf();
}

int CMBUpLoadNoteExReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) 
            + sizeof(m_dwAppUserID) + sizeof(m_szReserve));
}

void CMBUpLoadNoteExReq::ReleaseBuf()
{
//    std::list<NoteInfo *>::iterator it = m_lstPMBNoteInfoEx.begin();
//    while (it != m_lstPMBNoteInfoEx.end())
//    {
//        delete (*it);
//        *it = NULL;
//        ++it;
//    }
    m_lstPMBNoteInfoEx.clear();
}

int CMBUpLoadNoteExReq::Encode(char** pSend, uint32_t& unLen)
{
    int iRet = RET_SUCCESS;
    
    unLen = this->GetFixedLen() + sizeof(uint32_t);     
    
    uint32_t unAtomLen = 0;
    std::list<NoteInfo>::iterator it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        if (RET_SUCCESS != (iRet = (*it).GetObjSize(unAtomLen)))
        {
            return iRet;
        }
        
        unLen += unAtomLen;
        
        ++it;
    }
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);    
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, m_szReserve, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    
    uint32_t unCnt = (uint32_t)m_lstPMBNoteInfoEx.size();
    memcpy(p, &unCnt, sizeof(unCnt));
    p += sizeof(unCnt);    
    
    it = m_lstPMBNoteInfoEx.begin();
    while (m_lstPMBNoteInfoEx.end() != it)
    {
        memcpy(p, &(*it), offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        wcscpy_m(p, (char*)(*it).strTitle.c_str());
        p += ((*it).strTitle.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strAddr.c_str());
        p += ((*it).strAddr.length() + 1) * 2;
        wcscpy_m(p, (char*)(*it).strSrc.c_str());
        p += ((*it).strSrc.length() + 1) * 2;
        
//        wcscpy_m(p, (char*)(*it)->pwszTitle);
//        p += (wcslen_m((char*)(*it)->pwszTitle) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszAddr);
//        p += (wcslen_m((char*)(*it)->pwszAddr) + 1) * 2;
//        
//        wcscpy_m(p, (char*)(*it)->pwszSrc);
//        p += (wcslen_m((char*)(*it)->pwszSrc) + 1) * 2;
        
        ++it;
    }
    
    return RET_SUCCESS;
    
}


int CMBUpLoadNoteExReq::Decode(char* pRev, uint32_t unLen)
{
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += sizeof(uint32_t);
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    memcpy(m_szReserve, p, sizeof(m_szReserve));
    p += sizeof(m_szReserve);
    unOffSet += sizeof(m_szReserve); 
    
    uint32_t unCnt =  *((uint32_t *)p);
    p += sizeof(unCnt);
    unOffSet += sizeof(unCnt);
    
    m_lstPMBNoteInfoEx.clear();
    
    for (uint32_t i = 0; i < unCnt; i++)
    {
        unOffSet += offsetof(NoteInfo, strTitle);
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
        
        NoteInfo pMBNoteInfoEx;
        memcpy(&pMBNoteInfoEx, p, offsetof(NoteInfo, strTitle));
        p += offsetof(NoteInfo, strTitle);
        
        uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszTitle = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszTitle, p, unStrLen);
        pMBNoteInfoEx.strTitle = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszAddr = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszAddr, p, unStrLen);
        pMBNoteInfoEx.strAddr = (unichar*)p;
        
        p += unStrLen;
        
        unStrLen = (wcslen_m(p) + 1) * 2;
        unOffSet += unStrLen;
        if (unOffSet > unLen)
        {
            return RET_MB_MSG_ERR_LENGTH;
        }
//        pMBNoteInfoEx->pwszSrc = new unichar[unStrLen / 2];//已经把"\0"算进去了
//        memcpy(pMBNoteInfoEx->pwszSrc, p, unStrLen);
        pMBNoteInfoEx.strSrc = (unichar*)p;
        
        p += unStrLen;
        
        m_lstPMBNoteInfoEx.push_back(pMBNoteInfoEx);
    }
    
    return RET_SUCCESS;
}

// 用户登录　请求
CMBUserLoginReq::CMBUserLoginReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_nUserType         = 0;
    m_pwszUserName      = NULL;
    m_pwszPwd           = NULL;
}

CMBUserLoginReq::~CMBUserLoginReq()
{
    ReleaseBuf();
}

int CMBUserLoginReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_nUserType) + sizeof(m_MobileInfo));
}

void CMBUserLoginReq::ReleaseBuf()
{
    if (NULL != m_pwszUserName)
    {
        delete[] m_pwszUserName;
        m_pwszUserName = NULL;
    }
    
    if (NULL != m_pwszPwd)
    {
        delete[] m_pwszPwd;
        m_pwszPwd = NULL;
    }
    
}

int CMBUserLoginReq::Encode(char** pSend, uint32_t& unLen)
{
    if ((NULL == m_pwszUserName)
        || (NULL == m_pwszPwd))
    {
        return RET_MB_MSG_NULL_POINTER;
    }    
    
    unLen = this->GetFixedLen();
    
    unLen += (wcslen_m((char*)m_pwszUserName) + 1) * 2 + (wcslen_m((char*)m_pwszPwd) + 1) * 2;
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_nUserType, sizeof(m_nUserType));
    p += sizeof(m_nUserType);
    
    memcpy(p, &m_MobileInfo, sizeof(m_MobileInfo));
    p += sizeof(m_MobileInfo);
    
    wcscpy_m(p, (char*)m_pwszUserName);
    p += (wcslen_m((char*)m_pwszUserName) + 1) * 2;
    
    wcscpy_m(p, (char*)m_pwszPwd);
    p += (wcslen_m((char*)m_pwszPwd) + 1) * 2;
    
    return RET_SUCCESS;
}

int CMBUserLoginReq::Decode(char* pRev, uint32_t unLen)
{
    if (NULL == pRev)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    unMinLen += 3 * 2;//三个字符串的大小　每个至少要有一个"\0"
    
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_nUserType = *((int*)p);
    p += sizeof(m_nUserType);
    unOffSet += sizeof(m_nUserType);
    
    memcpy(&m_MobileInfo, (CMBMobileInfo *)p, sizeof(m_MobileInfo));
    p += sizeof(m_MobileInfo);
    unOffSet += sizeof(m_MobileInfo);
    
    uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
    unOffSet += unStrLen;
    if (unOffSet > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    m_pwszUserName = new unichar[unStrLen / 2];
    memcpy(m_pwszUserName, p, unStrLen);
    p += unStrLen;
    
    unStrLen = (wcslen_m(p) + 1) * 2;
    unOffSet += unStrLen;
    if (unOffSet > unLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    m_pwszPwd = new unichar[unStrLen / 2];
    memcpy(m_pwszPwd, p, unStrLen);
    p += unStrLen; 
    
    return RET_SUCCESS;
}



//用户登录　响应
CMBUserLoginAck::CMBUserLoginAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_nRetCode          = 0;
}

CMBUserLoginAck::~CMBUserLoginAck()
{
    ReleaseBuf();
}

int CMBUserLoginAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBUserLoginAck::ReleaseBuf()
{
    //do nothing
}

int CMBUserLoginAck::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();    
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    return RET_SUCCESS;
}

int CMBUserLoginAck::Decode(char* pRev, uint32_t unLen)
{
    if (NULL == pRev)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    ReleaseBuf();
    
    char *p = pRev;
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);  
    
    return RET_SUCCESS;
}


//用户登录EX　响应
CMBUserLoginExAck::CMBUserLoginExAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;
    m_dwAppUserID       = 0;
    m_nRetCode          = 0;
    memset(m_ucMasterKey, 0x0, sizeof(m_ucMasterKey));
}

CMBUserLoginExAck::~CMBUserLoginExAck()
{
    ReleaseBuf();
}

int CMBUserLoginExAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) 
            + sizeof(m_nRetCode) + sizeof(m_ucMasterKey));
}

void CMBUserLoginExAck::ReleaseBuf()
{
    //do nothing
}

int CMBUserLoginExAck::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();    
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    memcpy(p, &m_ucMasterKey, sizeof(m_ucMasterKey));
    p += sizeof(m_ucMasterKey);
    
    return RET_SUCCESS;
}

int CMBUserLoginExAck::Decode(char* pRev, uint32_t unLen)
{
    if (NULL == pRev)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    ReleaseBuf();
    
    char *p = pRev;
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);  
    
    m_nRetCode = *((int*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);  
    
    memcpy(m_ucMasterKey, p, sizeof(m_ucMasterKey));
    unOffSet += sizeof(m_ucMasterKey);
    
    return RET_SUCCESS;
}

// 用户注销登录　请求
CMBUserLogoutReq::CMBUserLogoutReq()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0;  
    m_dwAppUserID       = 0;
    //m_pwszUserName      = NULL;    
}

CMBUserLogoutReq::~CMBUserLogoutReq()
{
    ReleaseBuf();
}

int CMBUserLogoutReq::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID));
}

void CMBUserLogoutReq::ReleaseBuf()
{
    //     if (NULL != m_pwszUserName)
    //     {
    //         delete m_pwszUserName;
    //         m_pwszUserName = NULL;
    //     }   
}

int CMBUserLogoutReq::Encode(char** pSend, uint32_t& unLen)
{
    //     if (NULL == m_pwszUserName)        
    //     {
    //         return RET_MB_MSG_NULL_POINTER;
    //     }    
    
    unLen = this->GetFixedLen();
    
    //unLen += (wcslen_m(m_pwszUserName) + 1) * 2;
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    //     wcscpy_m(p, m_pwszUserName);
    //     p += (wcslen_m(m_pwszUserName) + 1) * 2;
    
    return RET_SUCCESS;
}

int CMBUserLogoutReq::Decode(char* pRev, uint32_t unLen)
{
    if (NULL == pRev)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    ReleaseBuf();
    
    uint32_t unMinLen = this->GetFixedLen();
    //unMinLen += 2;//一个字符串的大小 至少要有一个"\0"
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    char *p = pRev;
    
    uint32_t unOffSet = 0;
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    //     uint32_t unStrLen = (wcslen_m(p) + 1) * 2;
    //     unOffSet += unStrLen;
    //     if (unOffSet >= unLen)
    //     {
    //         return RET_MB_MSG_ERR_LENGTH;
    //     }
    // 
    //     m_pwszUserName = new wchar_tt[unStrLen / 2];
    //     memcpy(m_pwszUserName, p, unStrLen);
    //     p += unStrLen;
    
    return RET_SUCCESS;
}



//用户注销登录　响应
CMBUserLogoutAck::CMBUserLogoutAck()
{
    m_dwConnectionID    = 0;
    m_dwDbID            = 0; 
    m_dwAppUserID       = 0;
    m_nRetCode          = 0;
}

CMBUserLogoutAck::~CMBUserLogoutAck()
{
    ReleaseBuf();
}

int CMBUserLogoutAck::GetFixedLen()
{
    return (sizeof(m_dwConnectionID) + sizeof(m_dwDbID) + sizeof(m_dwAppUserID) + sizeof(m_nRetCode));
}

void CMBUserLogoutAck::ReleaseBuf()
{
    //do nothing
}

int CMBUserLogoutAck::Encode(char** pSend, uint32_t& unLen)
{
    unLen = this->GetFixedLen();    
    
    // 申请内存块用于发送数据    
    *pSend = new(std::nothrow) char[unLen];
    if (NULL == *pSend)
    {
        return RET_MB_MSG_MEM_BAD_ALLOC;
    }
    
    memset(*pSend, 0x0, unLen);
    
    //拼装数据
    char *p = *pSend;
    
    memcpy(p, &m_dwConnectionID, sizeof(m_dwConnectionID));
    p += sizeof(m_dwConnectionID);
    
    memcpy(p, &m_dwDbID, sizeof(m_dwDbID));
    p += sizeof(m_dwDbID);
    
    memcpy(p, &m_dwAppUserID, sizeof(m_dwAppUserID));
    p += sizeof(m_dwAppUserID);
    
    memcpy(p, &m_nRetCode, sizeof(m_nRetCode));
    p += sizeof(m_nRetCode);
    
    return RET_SUCCESS;
}

int CMBUserLogoutAck::Decode(char* pRev, uint32_t unLen)
{
    if (NULL == pRev)
    {
        return RET_MB_MSG_NULL_POINTER;
    }
    
    ReleaseBuf();
    
    char *p = pRev;
    
    uint32_t unMinLen = this->GetFixedLen();
    
    if (unLen < unMinLen)
    {
        return RET_MB_MSG_ERR_LENGTH;
    }
    
    uint32_t unOffSet = 0;//这个在没有指针的类中其实没有用
    
    m_dwConnectionID = *((uint32_t*)p);
    p += sizeof(m_dwConnectionID);
    unOffSet += sizeof(m_dwConnectionID);
    
    m_dwDbID = *((uint32_t*)p);
    p += sizeof(m_dwDbID);
    unOffSet += sizeof(m_dwDbID);
    
    m_dwAppUserID = *((uint32_t*)p);
    p += sizeof(m_dwAppUserID);
    unOffSet += sizeof(m_dwAppUserID);
    
    m_nRetCode = *((int*)p);
    p += sizeof(m_nRetCode);
    unOffSet += sizeof(m_nRetCode);  
    
    return RET_SUCCESS;
}

unsigned int getUnicodeLength(unsigned char *data) {
    if (data == NULL) {
        return 0;
    }
    
    int pos = 0;
    while (1)
    {
        unsigned char b1 = data[pos];
        unsigned char b2 = data[pos + 1];
        // 双字节 当遇到 00时表示结束
        if ((b1 == 0) && (b2 == 0))
        {
            break;
        }
        pos += 2;
    }
    return pos;
}
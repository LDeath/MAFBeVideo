#ifndef NVS_JPLAYER_SDK_H_
#define NVS_JPLAYER_SDK_H_

#ifdef WIN32
#include <stddef.h>
#include <windef.h>
#else
#endif
#include <time.h>

#ifdef WIN32
#ifdef NVSJPLAYERSDK_EXPORTS
#define NVS_API __declspec(dllexport)
#else
#define NVS_API __declspec(dllimport)
#endif //!NVSSDK_EXPORTS

#ifndef NVS_CALLBACK
#define NVS_CALLBACK CALLBACK
#endif

#ifndef NVS_METHOD
#define NVS_METHOD __stdcall
#endif
#else	//WIN32
#define NVS_API

#ifndef NVS_CALLBACK
#define NVS_CALLBACK
#endif

#ifndef NVS_METHOD
#define NVS_METHOD
#endif
#endif	//WIN32

#ifndef WIN32
#define LONG long
#endif

#define LLONG	long long

typedef enum
{
    JPLAYER_IPV4_LEN      = 30,
    JPLAYER_MAX_ID        = 32,
    JPLAYER_MAX_USERNAME  = 64,
    JPLAYER_NAME_LENGTH   = 256
} JPlayer_Constants;



typedef enum
{
    JPLAYER_MSG_NO_INIT_FAIL         = -1002,           /// 初始化失败
    JPLAYER_MSG_ERROR                = -1001,           /// 操作失败，通用错误
    
    JPLAYER_MSG_SUBSCRIBE_FAILED     = -1000,			/// 打开视频失败
    JPLAYER_MSG_VIDEO_IS_READY       = -999,	        /// 视频缓冲完毕
    JPLAYER_MSG_VIDEO_RESOLUTION     = -998,	        /// 视频分辨率改变
    
    JPLAYER_MSG_LOGIN_CONNECT_FAIL   = -997,            /// 登录时连接服务器失败
    JPLAYER_MSG_LOGIN_PASS_ERROR     = -996,            /// 登录密码错误
    JPLAYER_MSG_LOGIN_REFUSE         = -995,            /// 登录被拒绝
    
    JPLAYER_MSG_RECORD_ERROR         = -989,			/// 录像出现错误
    JPLAYER_MSG_RECORD_ENDSTREAM     = -988,			/// 录像被关闭
    JPLAYER_MSG_RECORD_INVALID_FILE  = -987,	        /// 无效的录像文件
    JPLAYER_MSG_RECORD_TIMER         = -977,	        /// 录像时间回调
    
    JPLAYER_MSG_SESSION_CLOSED       = -979,	        /// 播放会话已经关闭
    JPLAYER_MSG_SESSION_CONNECTED    = -978,	        /// 连接上流媒体分发服务
    
    JPLAYER_MSG_NORMAL = 0					            /// 正常
} JPlayer_ErrorCode;

///媒体暂停命令
typedef enum
{
    JPLAYER_CMD_RESUME  = 0x00,     //恢复
    JPLAYER_CMD_PAUSE   = 0x01,     //暂停
    
    JPLAYER_CMD_LENGTH
} JPlayer_Pause;


///媒体录像轨迹
typedef enum
{
    JPLAYER_MP4_VIDEO_TRACK = 1,    //视频轨迹
    JPLAYER_MP4_AUDIO_TRACK = 2     //音频轨迹
}JPlayer_MP4_RECORD;



///媒体数据帧类型
typedef enum
{
    JPLAYER_FRAME_PCM              = 1,
    JPLAYER_FRAME_G711A            = 2,
    JPLAYER_FRAME_G711U            = 3,
    JPLAYER_FRAME_OPUS             = 4,
    JPLAYER_FRAME_PUSHTALK_PCM     = 5,
    
    JPLAYER_FRAME_H264             = 16
}JPlayer_FrameType;


typedef enum
{
    JPLAYER_PTZ_CMD_START = 0,
    JPLAYER_PTZ_CMD_STOP = 1,
    
    JPLAYER_PTZ_CMD_RIGHT = 2,
    JPLAYER_PTZ_CMD_LEFT = 4,
    JPLAYER_PTZ_CMD_DOWN = 6,
    JPLAYER_PTZ_CMD_UP = 8,
    
    JPLAYER_PTZ_CMD_SMALL = 10,
    JPLAYER_PTZ_CMD_LARGE = 12,
    
    JPLAYER_PTZ_CMD_ZOOM_IN = 14,
    JPLAYER_PTZ_CMD_ZOOM_OUT = 16,
    
    JPLAYER_PTZ_CMD_FOCUS_IN = 18,
    JPLAYER_PTZ_CMD_FOCUS_OUT = 20,
    
    JPLAYER_PTZ_CMD_ASSIST_FUNC_1 = 30,
    JPLAYER_PTZ_CMD_ASSIST_FUNC_2 = 32,
    JPLAYER_PTZ_CMD_ASSIST_FUNC_3 = 34,
    JPLAYER_PTZ_CMD_ASSIST_FUNC_4 = 36,
    
    JPLAYER_PTZ_RIGHT_APPLY = 40,        // ptz 权限申请、释放
    JPLAYER_PTZ_RIGHT_RELEASE = 42,
    
    JPLAYER_PTZ_PRESET_ADD = 110,
    JPLAYER_PTZ_PRESET_MODIDY = 112,
    JPLAYER_PTZ_PRESET_DELETE = 114,
    JPLAYER_PTZ_PRESET_GOTO = 116,
    
    JPLAYER_PTZ_CMD_SCAN = 120,
    
    JPLAYER_PTZ_CRUISE_DELETE = 130,
    JPLAYER_PTZ_CRUISE_START = 132,
    JPLAYER_PTZ_CRUISE_STOP = 134,
    JPLAYER_PTZ_CRUISE_PAUSE = 136,
    JPLAYER_PTZ_CRUISE_RESUME = 138,
    
    
    JPLAYER_PTZ_CMD_LENGTH
}JPlayer_PTZCommand;


typedef struct
{
    char m_id[JPLAYER_MAX_ID];
    int  m_cmd;    ///@see JPlayer_PtzCommand
    int  m_speed;  ///速度 1---64
    int  m_data;   ///附加数据，对于云台动作为JPLAYER_PTZ_CMD_START开始/JPLAYER_PTZ_CMD_STOP停止，对于预置位为编号
}JPlayer_PtzRequest;



///播放器版本信息
typedef struct
{
    char    m_version[JPLAYER_MAX_USERNAME];   //版本
    char    m_desc[JPLAYER_MAX_USERNAME];      //描述
} JPlayer_Info;


///登录服务器信息描述
typedef struct
{
    char    m_serverIp[JPLAYER_IPV4_LEN];           ///cmu ip地址
    int     m_serverPort;                           ///cmu端口
    char    m_userName[JPLAYER_MAX_USERNAME];       ///用户名
    char    m_password[JPLAYER_MAX_USERNAME];       ///密码
    int     m_linkType;                             ///信令类型，0：tcp-sip  1：udp-sip 2：tcp
}JPlayer_LoginPara;



///登录服务器信息描述
typedef struct
{
    char    m_channelId[JPLAYER_MAX_ID];      ///摄像头编码
}JPlayer_PlaySession;


///查询录像信息请求
typedef struct
{
    char  m_channelId[JPLAYER_MAX_ID];        ///摄像头编码
    LLONG m_beginTime;                        ///开始时间
    LLONG m_endTime;                          ///结束时间
    int   m_type;                             ///录像类型，保留
}JPlayer_QueryRecordRequest;


///录像信息
typedef struct
{
    char  m_channelId[JPLAYER_MAX_ID]; ///摄像头编码
    LLONG m_beginTime;                 ///实际开始时间
    LLONG m_endTime;                   ///实际结束时间
    int   m_type;                      ///录像类型
}JPlayer_RecordItem;


///查询录像信息响应
typedef struct
{
    int  m_sum;                       ///输入限制返回的总数目，即pItems的内存长度；返回实际的录像信息数量
    JPlayer_RecordItem* m_pItems;     ///录像信息结构
}JPlayer_QueryRecordResponse;


///目录树节点信息结构
typedef struct
{
    char    m_id[JPLAYER_MAX_ID];          ///节点资源编码id,(摄像头或目录结构）
    char    m_parentId[JPLAYER_MAX_ID];    ///父节点资源编码id
    char    m_serverId[JPLAYER_MAX_ID];    ///接入服务器id
    char    m_encoderId[JPLAYER_MAX_ID];   ///编码器id
    char    m_name[JPLAYER_NAME_LENGTH];   ///节点名称
    int     m_type;		                   ///节点类型，1为目录,2为摄像头
    int     m_status;                      ///节点状态，0为离线，1为 在线
    int     m_userRight;	                // 用户权限集合
    double  m_longitude;                    /// 经度
    double  m_latitude;                     /// 纬度
}JPlayer_ResourceItem;


///目录树请求
typedef struct
{
    char m_id[JPLAYER_MAX_ID];    //目录节点资源编码id
    int  m_pageNum;               //分页数，从0页开始请求
}JPlayer_ResourceRequest;


///目录树请求响应
typedef struct
{
    int  m_itemCount;             ///输入输出类型，输入的是内存数组总长度，输出是实际可用的内存数组长度
    JPlayer_ResourceItem* m_pItems;       ///资源内存数组
}JPlayer_ResourceResponse;




#ifdef __cplusplus
extern "C"
{
#endif
    
    
    
    /// 初始化.
    ///	@param avSyncMode   音视频同步模式，0以视频为轴，1音频 2不同步
    /// @return JPLAYER_MSG_NORMAL成功，其它失败
    NVS_API LONG NVS_METHOD NVS_JPlayer_Init(LONG avSyncMode);
    
    /// 释放SDK资源.
    /// @return JPLAYER_MSG_NORMAL成功，其它失败
    NVS_API LONG NVS_METHOD NVS_JPlayer_Cleanup();
    
    
    
    /// 获取播放器的描述信息.
    /// @param pInfo   库的描述信息
    /// @return TRUE-成功，FALSE-失败
    NVS_API LONG NVS_METHOD NVS_JPlayer_GetLibraryInfo(JPlayer_Info* pInfo);
    
    
    /// 获取当前会话错误的错误码.
    /// @param[in] lHandle  会话句柄
    /// @return  错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_GetLastError(LONG lHandle);
    
    
    /// 消息回调函数
    /// @param[in] lHandle  会话句柄
    /// @param[in] lCommand 消息的类型,JPlayer_ErrorCode
    /// @param[in] para1    回调数据参数1
    /// @param[in] para2    回调数据参数2
    /// @param[in] dwUser   用户数据
    /// @return 错误码
    typedef LONG (NVS_CALLBACK *JPlayerMsgCallBack)(LONG  lHandle,
    LONG  lCommand,
    LLONG para1,
    LLONG para2,
    LONG  dwUser
    );
    
    
    /// 设置和服务器的会话消息回调.
    /// @param[in] jpMsgCallback 消息回调
    /// @param[in] dwUser   用户数据
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetMsgCallBack(
                                                       JPlayerMsgCallBack jpMsgCallback,
                                                       LONG dwUser);
    
    
    /// 流量计算回调函数
    /// @param[in] lHandle   会话句柄
    /// @param[in] dvbps     播放器下行视频每秒字节数
    /// @param[in] dabps     播放器下行音频每秒字节数
    /// @param[in] dvfps     播放器下行视频每秒帧数
    /// @param[in] dafps     播放器下行音频每秒帧数
    /// @param[in] dwUser    用户数据
    /// @return              错误码
    typedef LONG (NVS_CALLBACK *JPlayerBDCallBack)(LONG lHandle,
    LONG dvbps,
    LONG dabps,
    LONG dvfps,
    LONG dafps,
    LONG dwUserm
    );
    
    
    
    /// 设置回调.
    /// @param[in] lHandle      会话句柄
    /// @param[in] nSecond      几秒统计一次
    /// @param[in] jpBDCallback 消息回调
    /// @param[in] dwUser       用户数据
    /// @return                 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetBDCallBack(
                                                      LONG lHandle,
                                                      unsigned int nSecond,
                                                      JPlayerBDCallBack jpBDCallback,
                                                      LONG dwUser);
    
    
    /// 登录服务器.
    /// @param sess  会话参数
    /// @return      0成功，其它失败
    NVS_API LONG NVS_METHOD NVS_JPlayer_Login(JPlayer_LoginPara *pSess);
    
    
    /// 注销登录.
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Logout();
    
    
    /// 设置播放模式
    /// @param[in] mode  0实时优先，1流畅优先
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetPlayMode(LONG mode);
    
    /// 获取用户指定节点的目录树资源.
    /// @param[in] req  节点请求
    /// @param[in] resp 资源响应
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_QuerySubResource(JPlayer_ResourceRequest *req,
                                                         JPlayer_ResourceResponse* resp);
    
    /// 录像查询.
    /// @param[in] req  查询输入条件
    /// @param[in] resp 查询结果
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_QueryRecord(JPlayer_QueryRecordRequest *req,
                                                    JPlayer_QueryRecordResponse* resp) ;
    
    
    
    /// 打开和流媒体服务器的会话.
    /// @return      会话句柄（ 成功 != 0），
    NVS_API LONG NVS_METHOD NVS_JPlayer_Open();
    
    
    /// 关闭和流媒体服务器的会话.
    /// @param[in] lHandle 会话句柄
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Close(LONG lHandle);
    
    
    
    /// 开始播放实时视频.
    /// @param[in] lHandle 会话句柄
    /// @param sess  会话参数
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Play_Live(LONG lHandle,
                                                  JPlayer_PlaySession *pSess);
    
    /// 云镜控制.
    /// @param[req]  云镜控制参数
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_ControlPtz(const JPlayer_PtzRequest& req);
    
    
    // 开始播放历史视频.
    /// @param[in] lHandle 会话句柄
    /// @param[in] item    历史视频信息
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Play_Record(LONG lHandle,
                                                    JPlayer_RecordItem item);
    
    /// 停止播放.
    /// @param[in] lHandle 会话句柄
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Stop(LONG lHandle);
    
    /// 开始播放音频.
    /// @param[in] lHandle 会话句柄
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_PlaySound(LONG lHandle);
    
    /// 停止播放音频.
    /// @param[in] lHandle 会话句柄
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_StopSound(LONG lHandle);
    
    
    /// 设置音频编码参数.
    /// @param[in] lHandle 会话句柄
    /// @param[in] sampleRate 采样率
    /// @param[in] channel    通道个数
    /// @param[in] fps        音频采集帧率
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetAudioEncode(LONG lHandle,
                                                       int sampleRate,
                                                       int channel,
                                                       int fps);
    
    /// 设置音频解码参数
    /// @param[in] lHandle 会话句柄
    /// @param[in] sampleRate 采样率
    /// @param[in] channel    通道个数
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetAudioDecode(LONG lHandle,
                                                       int sampleRate,
                                                       int channel);
    
    
    
    /// 输入媒体，用于文件或者流式等无网络传输的应用.
    /// @param[in] lHandle   会话句柄
    /// @param[in] frameType 帧类型  see@JPlayer_FrameType
    /// @param[in] isKey     是否关键帧
    /// @param[in] pFrame    数据指针
    /// @param[in] frameLength 数据长度
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_InputStream(LONG lHandle,
                                                    unsigned int   frameType,
                                                    int            isKey,
                                                    unsigned char* pFrame,
                                                    unsigned int   frameLength);
    
    /// 发送消息给信令服务
    /// @param[in] lHandle 会话句柄
    /// @param[in] pMsg    消息内容
    /// @return    错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SendMessage(LONG lHandle,const char *pMsg);
    
    
    
    /// 设置音频音量
    /// @param  volume 音量，范围为：[0-100], 0 表示静音
    /// @return 错误码
    
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetVolume(unsigned int  volume);
    
    
    /// 获取音量
    /// @param  pVolume 音量
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_GetVolume(unsigned int*  pVolume);
    
    
    /// 抓图.
    /// @param[in] lHandle 会话句柄
    /// @param[in] path    文件路径
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Snap(LONG lHandle,const char *path);
    
    
    /// 设置倍速播放.
    /// @param[in] lHandle 会话句柄
    /// @param[in] scale   播放速度 ，取值范围 （1/4 --- 4.0）
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetScale(LONG lHandle,float scale);
    
    
    /// 获取倍速播放
    /// @param[in] lHandle 会放句柄
    /// @return 播放速度 ，取值范围 （1/4 --- 4.0）
    NVS_API float NVS_METHOD NVS_JPlayer_GetScale(LONG lHandle);
    
    
    /// 设置播放的相对位置.
    /// @param[in] lHandle 会话句柄
    /// @param[in] lRelativePos 播放位置，
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_SetPlayPos(LONG lHandle, LLONG lRelativePos);
    
    /// 获得播放的相对位置.
    /// @param[in] lHandle 会话句柄
    /// @return 播放位置,
    NVS_API LLONG NVS_METHOD NVS_JPlayer_GetPlayPos(LONG lHandle);
    
    
    
    /// 暂停/恢复播放.
    /// @param[in] lHandle 会话句柄
    /// @param[in] nPause 标识，1-暂停 其他值表示恢复播放
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_Pause(LONG lHandle,unsigned int nPause);
    
    
    /// 开始录像.
    /// @param[in] lHandle 会话句柄
    /// @param[in] track  @see JPlayer_MP4_RECORD
    ///                    JPLAYER_MP4_VIDEO_TRACK只录视频
    ///                    JPLAYER_MP4_AUDIO_TRACK只录音频
    ///                    JPLAYER_MP4_VIDEO_TRACK | JPLAYER_MP4_VIDEO_TRACK 录音视频
    /// @param[in] path   路径，目前只支持MP4容器，其中视频格式为H264，音频为小端PCM16
    /// @return 错误码，注：同时只能录像一个文件，录像启动失败可能会通过消息回调通知JPLAYER_MSG_RECORD_ERROR错误
    NVS_API LONG NVS_METHOD NVS_JPlayer_StartRecord(LONG lHandle,
                                                    int track,
                                                    const char *path);
    
    
    /// 停止录像.
    /// @param[in] lHandle 会话句柄
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_StopRecord(LONG lHandle);
    
    
    
    /// 手机当摄像头时输入媒体流.
    /// @param[in] channel   保留
    /// @param[in] frameType 帧类型  see@JPlayer_FrameType
    /// @param[in] pFrame    数据指针
    /// @param[in] frameLength 数据长度
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_CameraInputStream(LONG channel,
                                                          unsigned int  fps,
                                                          unsigned int  width,
                                                          unsigned int  height,
                                                          unsigned int   frameType,
                                                          unsigned char* pFrame,
                                                          unsigned int   frameLength);
    
    /// 手机当摄像头时注销
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_CameraLogout();
    
    
    /// 手机当摄像头时登录平台
    /// @param[in] url    平台参数地址
    /// @return 错误码
    NVS_API LONG NVS_METHOD NVS_JPlayer_CameraLogin(const char *url);
    
#ifdef __cplusplus
}
#endif

#endif //!NETPOSA_JPLAYER_SDK_H_



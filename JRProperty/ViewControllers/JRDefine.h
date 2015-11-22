//正则表达式
#define EMAIL_REGULAR_EXPRESSION @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
#define USER_REGULAR_EXPRESSION @"^[0-9A-Za-z_]{6,20}$"
#define PSW_REGULAR_EXPRESSION @"^[A-Za-z0-9_]{6,20}$"
#define PSW_REGULAR_FORLOGIN  @"^[^ ]{6,20}$"
#define MOBILE_REGULAR_EXPRESSION @"^[0-9]{11}$"
#define ZIP_REGULAR_EXPRESSION @"^[0-9]{0,6}$"
#define AUTHCODE_REGULAR_EXPRESSION @"^[0-9]{1,10}$"
#define POSTCODE_REGULAR_EXPRESSION @"^[0-9]{6}$"
//正整数
#define POSITIVE_NUMBER_REGULAR_EXPRESSION   @"^[0-9]*[1-9][0-9]*$"
//非负浮点数
#define POSITIVE_FLOAT_REGULAR_EXPRESSION   @"^\\d+(\\.\\d+)?$"

#define IDNUMBER_REGULAR_EXPRESSION  @"[0-9]{17}([0-9]|[xX])"
#define RETURN_CODE_SUCCESS                  @"000000"     //成功
#define OTHER_ERROR_MESSAGE   @"请求失败，请稍后再试"
#define NONE_DATA_MESSAGE   @"很抱歉，暂无数据"

// 如果ucid==nil 游客登录 否则用户登录 dw update
#define CID_FOR_REQUEST [[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]:([[NSUserDefaults standardUserDefaults] valueForKey:@"cid"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"cid"]:@"1")// 小区id
// dw add V1.1 添加超级管理员标示
#define IS_SUPER_REQUEST [[NSUserDefaults standardUserDefaults] valueForKey:@"isSuper"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"isSuper"]:@"0"
// dw end

#define NUMBER_FOR_REQUEST @"10" //一次请求条数
//当前设备屏幕高度
#define UIScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define UIScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define RETINA4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//系统版本
#define CURRENT_VERSION [[UIDevice currentDevice].systemVersion floatValue]
//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGB(a, b, c) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:1.0f]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
//通知
#define  CREATE_CRICLE_SUCCESS      @"createCircleSuccess" //创建圈子成功
#define  EDIT_CRICLE_SUCCESS        @"editCircleSuccess"//编辑圈子成功
#define  UPDATE_USERINFO_SUCCESS    @"updateUserInfoSuccess"//用户信息修改成功
#define  PUBLICE_ARTICLE_SUCCESS    @"publicNewArticleSuccess"//发帖成功
#define  LOGIN_SUCCESS              @"loginSuccess"//登陆成功
#define  UPDATE_FOR_JOINORQUIT      @"updateForJoinOrQuitCircle"//关注或取消关注圈子 成功
//圈子新消息提醒
#define  HAS_NEW_MESSAGE           @"hasNewMessage"// 
//登录消息通知
#define  LOGIN_SUCCESS_NOTIFICATION   @"LoginSuccessNotification"
//退出登陆通知
#define  LOGIN_OUT_NOTIFICATION       @"LoginOutNotification"
//通知设置页面刷新
#define  MYSETTING_REFRESH_NOTIFICATION       @"RefreshMySettingNotification"

#define  LOGIN_ACCOUNT_PHONE          @"accountPhone"
#define  LOGIN_ACCOUNT_PASSWORD       @"accountPassword"
#define  VERSION_LAST_CHECKED_KEY     @"lastCheckedVersionKey"     // 上一次检查的版本号

#define  VERSION_GUIDE_KEY            @"VersionKey"     // 获取本地存储的是否需要引导页版本的key
#define  VERSION_NUM_FOR_GUIDE        1  // 备注：如果需要显示新的引导页，该变量＋1
#define  VERSION_NUM_FOR_DB           2

/********************************* 接口地址  勿删 ********************************************/

//涂高峰
//#define  SERVER_URL      @"http://10.167.130.170/x8-mobile-gw-web/"
//测试服务器
//#define  SERVER_URL      @"http://mobile.myx8.cn/"
#define  SERVER_URL   @"http://mobile.crossroad.love/"
// APP下载地址
#define  HTTP_APP_DOWNLOAD_URL @"http://d.crossroad.love/app/download.html"
// 隐私协议地址
#define  HTTP_PRIVACY_URL [NSString stringWithFormat:@"%@licenseAgreement.html",SERVER_URL]
// 分享的轮播广告地址
#define  HTTP_SHARED_AD_URL [NSString stringWithFormat:@"%@index.html?flag=0&id=", SERVER_URL]
// 分享的话题地址
#define  HTTP_SHARED_ARTICLE_URL [NSString stringWithFormat:@"%@index.html?flag=1&id=", SERVER_URL]


/****************************** 主页接口 **********************************************/

// 3.1.1	初始化
#define  HTTP_Bus100101_URL [NSString stringWithFormat:@"%@Bus100101?encrypt=none", SERVER_URL]
// 3.1.2	轮播通告—列表查询
#define  HTTP_Bus100201_URL [NSString stringWithFormat:@"%@Bus100201?encrypt=none", SERVER_URL]
// 3.1.3	轮播通告—详情查询
#define  HTTP_Bus100301_URL [NSString stringWithFormat:@"%@Bus100301?encrypt=none", SERVER_URL]
// 3.1.4	轮播通告—赞&踩
#define  HTTP_Bus100401_URL [NSString stringWithFormat:@"%@Bus100401?encrypt=none", SERVER_URL]
// 3.1.5	轮播通告—评论
#define  HTTP_Bus100501_URL [NSString stringWithFormat:@"%@Bus100501?encrypt=simple", SERVER_URL]
// 3.1.6	门禁通行证
#define  HTTP_Bus100601_URL [NSString stringWithFormat:@"%@Bus100601?encrypt=simple", SERVER_URL]
// 3.1.7	我的消息查询
#define  HTTP_Bus100701_URL [NSString stringWithFormat:@"%@Bus100701?encrypt=simple", SERVER_URL]
// 3.1.8	便民信息查询
#define  HTTP_Bus100801_URL [NSString stringWithFormat:@"%@Bus100801?encrypt=none", SERVER_URL]
// 3.1.9	新鲜事儿查询
#define  HTTP_Bus100901_URL [NSString stringWithFormat:@"%@Bus100901?encrypt=none", SERVER_URL]
// 3.1.10	我的账单—账单查询
#define  HTTP_Bus101001_URL [NSString stringWithFormat:@"%@Bus101001?encrypt=simple", SERVER_URL]
// 3.1.11	我的账单—缴费清单查询
#define  HTTP_Bus101101_URL [NSString stringWithFormat:@"%@Bus101101?encrypt=simple", SERVER_URL]
// 3.1.12   APP用户提醒（用于查询新消息，圈子回复等数量）
#define  HTTP_Bus101201_URL [NSString stringWithFormat:@"%@Bus101201?encrypt=simple",SERVER_URL]
// 3.1.13   小区检索 v1.1.0
#define  HTTP_Bus101301_URL [NSString stringWithFormat:@"%@Bus101301?encrypt=simple",SERVER_URL]



/****************************** 物业服务接口 **********************************************/
// 3.2.1	工单提交—报修&投诉&表扬
#define  HTTP_Bus200101_URL [NSString stringWithFormat:@"%@Bus200101?encrypt=simple", SERVER_URL]
// 3.2.2	工单列表查询	25
#define  HTTP_Bus200201_URL [NSString stringWithFormat:@"%@Bus200201?encrypt=simple", SERVER_URL]
// 3.2.3	工单详情查询
#define  HTTP_Bus200301_URL [NSString stringWithFormat:@"%@Bus200301?encrypt=simple", SERVER_URL]
// 3.2.4	工单评价
#define  HTTP_Bus200401_URL [NSString stringWithFormat:@"%@Bus200401?encrypt=simple", SERVER_URL]



/****************************** 邻里接口 **********************************************/
//广场查询
#define  HTTP_Bus300101_URL [NSString stringWithFormat:@"%@Bus300101?encrypt=none", SERVER_URL]
//圈子列表查询
#define  HTTP_Bus300201_URL [NSString stringWithFormat:@"%@Bus300201?encrypt=none", SERVER_URL]
//我关注的  动态
#define  HTTP_Bus300301_URL [NSString stringWithFormat:@"%@Bus300301?encrypt=none", SERVER_URL]
//圈子基本信息
#define  HTTP_Bus300401_URL [NSString stringWithFormat:@"%@Bus300401?encrypt=none", SERVER_URL]
//圈子话题列表
#define  HTTP_Bus300501_URL [NSString stringWithFormat:@"%@Bus300501?encrypt=none", SERVER_URL]
//圈子 关注 取消关注
#define  HTTP_Bus300601_URL [NSString stringWithFormat:@"%@Bus300601?encrypt=simple", SERVER_URL]
//圈子 发表话题
#define  HTTP_Bus300701_URL [NSString stringWithFormat:@"%@Bus300701?encrypt=simple", SERVER_URL]
//圈子话题 点赞 取消赞
#define  HTTP_Bus300801_URL [NSString stringWithFormat:@"%@Bus300801?encrypt=simple", SERVER_URL]
//圈子 话题 分享
#define  HTTP_Bus300901_URL [NSString stringWithFormat:@"%@Bus300901?encrypt=none", SERVER_URL]
//圈子话题 投票
#define  HTTP_Bus301001_URL [NSString stringWithFormat:@"%@Bus301001?encrypt=simple", SERVER_URL]
//圈子话题 发表评论
#define  HTTP_Bus301101_URL [NSString stringWithFormat:@"%@Bus301101?encrypt=simple", SERVER_URL]
//圈子话题 评论列表
#define  HTTP_Bus301201_URL [NSString stringWithFormat:@"%@Bus301201?encrypt=none", SERVER_URL]
//圈子用户基本信息
#define  HTTP_Bus301301_URL [NSString stringWithFormat:@"%@Bus301301?encrypt=none", SERVER_URL]
//圈子用户发表的话题查询
#define  HTTP_Bus301401_URL [NSString stringWithFormat:@"%@Bus301401?encrypt=none", SERVER_URL]
//圈子 用户创建圈子
#define  HTTP_Bus301501_URL [NSString stringWithFormat:@"%@Bus301501?encrypt=simple", SERVER_URL]
//圈子 用户删除圈子
#define  HTTP_Bus301601_URL [NSString stringWithFormat:@"%@Bus301601?encrypt=simple", SERVER_URL]
//圈子 用户编辑圈子信息
#define  HTTP_Bus301701_URL [NSString stringWithFormat:@"%@Bus301701?encrypt=simple", SERVER_URL]
//圈子 话题置顶 取消置顶 删除
#define  HTTP_Bus301801_URL [NSString stringWithFormat:@"%@Bus301801?encrypt=simple", SERVER_URL]
//圈子 话题详情
#define  HTTP_Bus301901_URL [NSString stringWithFormat:@"%@Bus301901?encrypt=none", SERVER_URL]

//举报话题
#define  HTTP_Bus302201_URL [NSString stringWithFormat:@"%@Bus302201?encrypt=simple", SERVER_URL]

// 圈子 社区-社区话题转移 V1.1
#define  HTTP_Bus302001_URL [NSString stringWithFormat:@"%@Bus302001?encrypt=simple", SERVER_URL]
// 圈子 社区-新消息列表 V1.1
#define  HTTP_Bus302101_URL  [NSString stringWithFormat:@"%@Bus302101?encrypt=simple", SERVER_URL]

/****************************** 会员接口 **********************************************/


// 3.4.1	注册
#define  HTTP_Bus400101_URL [NSString stringWithFormat:@"%@Bus400101?encrypt=none", SERVER_URL]
// 3.4.2	登录
#define  HTTP_Bus400201_URL [NSString stringWithFormat:@"%@Bus400201?encrypt=none", SERVER_URL]
// 3.4.3	通知服务器发送短信验证码
#define  HTTP_Bus400301_URL [NSString stringWithFormat:@"%@Bus400301?encrypt=none", SERVER_URL]
// 3.4.4	个人信息查询
#define  HTTP_Bus400401_URL [NSString stringWithFormat:@"%@Bus400401?encrypt=simple", SERVER_URL]
// 3.4.5	头像上传
#define  HTTP_Bus400501_URL [NSString stringWithFormat:@"%@Bus400501?encrypt=none", SERVER_URL]
// 3.4.6	个人信息修改
#define  HTTP_Bus400601_URL [NSString stringWithFormat:@"%@Bus400601?encrypt=simple", SERVER_URL]
// 3.4.7	修改密码
#define  HTTP_Bus400701_URL [NSString stringWithFormat:@"%@Bus400701?encrypt=simple", SERVER_URL]
// 3.4.8	忘记密码—验证用户名
#define  HTTP_Bus400801_URL [NSString stringWithFormat:@"%@Bus400801?encrypt=none", SERVER_URL]
// 3.4.9	忘记密码—设置新密码
#define  HTTP_Bus400901_URL [NSString stringWithFormat:@"%@Bus400901?encrypt=none", SERVER_URL]
// 3.4.10	房屋—通过小区检索房屋信息
#define  HTTP_Bus401001_URL [NSString stringWithFormat:@"%@Bus401001?encrypt=none", SERVER_URL]
// 3.4.11	房屋—绑定房屋
#define  HTTP_Bus401101_URL [NSString stringWithFormat:@"%@Bus401101?encrypt=none", SERVER_URL]
// 3.4.12	房屋—账号绑定的房屋列表查询
#define  HTTP_Bus401201_URL [NSString stringWithFormat:@"%@Bus401201?encrypt=simple", SERVER_URL]
// 3.4.13	房屋—房下账号查询
#define  HTTP_Bus401301_URL [NSString stringWithFormat:@"%@Bus401301?encrypt=simple", SERVER_URL]
// 3.4.14	房屋—业主冻结&恢复房下账号
#define  HTTP_Bus401401_URL [NSString stringWithFormat:@"%@Bus401401?encrypt=simple", SERVER_URL]
// 3.4.15	房屋—用户解绑房屋
#define  HTTP_Bus401501_URL [NSString stringWithFormat:@"%@Bus401501?encrypt=simple", SERVER_URL]



/****************************** 设置接口 **********************************************/
// 3.5.1	意见反馈
#define  HTTP_Bus500101_URL [NSString stringWithFormat:@"%@Bus500101?encrypt=none", SERVER_URL]
// 3.5.2	版本更新检查
#define  HTTP_Bus500201_URL [NSString stringWithFormat:@"%@Bus500201?encrypt=none", SERVER_URL]
// 3.5.3	崩溃日志上传
#define  HTTP_Bus500301_URL [NSString stringWithFormat:@"%@Bus500301?encrypt=none", SERVER_URL]


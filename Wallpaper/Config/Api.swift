//
//  Api.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/26.
//

import Foundation
//请求域名
let baseURL = "https://2041a8770cfc5833.itqingjiao.com"

/*----------------------------首页接口---------------------------*/
//首页
let homeURL = baseURL + "/api/index/index"
//热门
let hotURL = baseURL + "/api/index/hot"
//分类
let categoryURL = baseURL + "/api/index/wallpaper"
//分类列表
let categoryListURL = baseURL + "/api/index/category"
//壁纸浏览数加一
let viewAddURL = baseURL + "/api/index/view"


/*----------------------------手机短信接口---------------------------*/
//发送验证码
let sendCodeURL = baseURL + "/api/sms/send"
//检测验证码
let checkCodeURL = baseURL + "/api/sms/check"


/*----------------------------验证接口---------------------------*/
//验证邮箱
let checkEmailURL = baseURL + "/api/validate/check_email_available"
//验证用户名
let checkUserNameURL = baseURL + "/api/validate/check_username_available"
//检测昵称
let checkNicknameURL = baseURL + "/api/validate/check_nickname_available"
//检测手机
let checkPhoneURL = baseURL + "/api/validate/check_mobile_available"
//检测手机号是否存在
let checkPhoneExistURL = baseURL + "/api/validate/check_mobile_exist"
//检测邮箱是否存在
let checkEmailExistURL = baseURL + "/api/validate/check_email_exist"
//检测手机验证码
let checkSmsURL = baseURL + "/api/validate/check_sms_correct"
//检测邮箱验证码
let checkEmsURL = baseURL + "/api/validate/check_ems_correct"



/*----------------------------会员接口---------------------------*/
//手机验证码登录
let mobileLoginURL = baseURL + "/api/user/mobilelogin"
//壁纸收藏
let addFavURL = baseURL + "/api/user/addfav"
//壁纸取消收藏
let delFavURL = baseURL + "/api/user/delfav"
//壁纸收藏列表
let favListURL = baseURL + "/api/user/favlist"
//退出登录
let loginOutURL = baseURL + "/api/user/logout"



/*----------------------------Token接口---------------------------*/
//检测Token是否过期
let checkTokenURL = baseURL + "/api/token/check"
//刷新Token
let refreshTokenURL = baseURL + "/api/token/refresh"



/*----------------------------邮箱验证码接口---------------------------*/
//发送邮箱验证码
let emsSendURL = baseURL + "/api/ems/send"
//检测邮箱验证码
let emsCheckURL = baseURL + "/api/ems/check"




/*----------------------------公共接口---------------------------*/
//加载初始化
let commonURL = baseURL + "/api/common/init"

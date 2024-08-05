//
//  Network.swift
//  GHLib
//
//  Created by GH on 7/2/24.
//

import Moya
import SwiftyJSON
import GoogleSignIn

@MainActor
public class NetworkManager {
    public static let shared = NetworkManager()
    
    private static let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Session(configuration: configuration)
    }()
    
    public var provider: MoyaProvider<MultiTarget>
    public var pluginProvider: MoyaProvider<MultiTarget>
    public var testProvider: MoyaProvider<MultiTarget>
    
    private init() {
        self.provider = MoyaProvider<MultiTarget>(session: NetworkManager.session)
        self.pluginProvider = MoyaProvider<MultiTarget>(session: NetworkManager.session, plugins: [CustomLoggerPlugin()])
        self.testProvider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
    }

//    /// 判断回传 JSON 的字段值是否符合预期条件
//    /// - Parameters:
//    ///   - json: JSON 实例
//    ///   - successFeedback: 是否在成功时开启反馈震动，默认为 false
//    ///   - failureFeedback: 是否在失败时开启反馈震动，默认为 false
//    ///   - successAction: 当 JSON 中的指定字段值符合预期条件时执行的闭包，传递 `json["data"]` 作为参数
//    ///   - failureAction: 当 JSON 中的指定字段值不符合预期条件时执行的可选闭包
//    ///
//    /// - Author: GH
//    public static func codeOK(_ json: JSON, successFeedback: Bool = false, failureFeedBack: Bool = false, successAction: (_ data: JSON) -> Void, failureAction: (() -> Void)? = nil) {
//        let condition = ModuleConfig.shared.successCondition
//        let key = condition.keys.first!
//        let value = condition.values.first!
//        
//        if json[key].stringValue == value {
//            if successFeedback {
//                Hap.success()
//                ToastManager.shared.completeToast(title: json["message"].stringValue)
//            }
//#if DEBUG
//            print("---Successful---")
//            print("Code: \(json[key].stringValue)")
//            print("Message: \(json["message"].stringValue)")
//            print(json["data"])
//            print("---Done---")
//#endif
//            successAction(json["data"])
//        } else {
//            if failureFeedBack { Hap.error() }
//#if DEBUG
//            print("Error message: \n\(json["message"])")
//#endif
//            // 显示错误的 Toast
//            ToastManager.shared.HUDToast(successful: false, title: json["message"].stringValue)
//            failureAction?()
//        }
//    }
    
    // TODO: 使用 Apple 登陆/注册 封装进来
    /// 使用 Google 登陆
    /// - Parameter completion: 使用获取的 Google Token 处理 closure
    ///
    /// - Author: GH
    public func authWithGoogle(completion: @escaping (_ token: String?) -> Void) {
        // 使用 GIDSignIn 的 signIn，使用 getRootView Controller 获取当前 View Controller，将 Action Button 显示于当前 View Controller 上
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            guard error == nil else {
                print("Authentication error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            // 获取 Google Token
            let googleToken = result?.user.idToken?.tokenString
            
            print("Google Token: \(googleToken ?? "nil")")
            
            completion(googleToken)
        }
    }
    
    
    /// 释放资源（清理缓存 + 取消请求）
    ///
    /// - Author: GH
    public func releaseResources() {
        // 清理缓存
        URLCache.shared.removeAllCachedResponses()
        
        // 取消所有正在进行的网络请求
        cancelAllRequests()
        
        print("NetworkManager resources released.")
    }
    
    /// 取消所有请求
    ///
    /// - Author: GH
    private func cancelAllRequests() {
        provider.session.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        
        pluginProvider.session.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
}

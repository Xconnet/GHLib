//
//  Token.swift
//  CoreModule
//
//  Created by GH on 7/2/24.
//

import Foundation
import SwiftyJSON

public actor TokenManager {
    public static let shared = TokenManager()
    
    /// 初始化时，将 Keychain 的 Token 取出
    private init() {
        accessToken = KeychainManager.shared.getAccessTokenFromKeychain()
    }
    
    /// Token
    private var accessToken: String?
    /// 标记是否进入刷新流程
    private var isRefreshing = false
    
    /// 挂起的请求
    private var pendingRequests: [(String?) -> Void] = []
    
    /// 提供一个同步方法来获取当前 Token
    /// - Returns: 当前有效的 Token
    ///
    /// - Author: GH
    public static func getTokenSync() -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: String?
        
        Task {
            result = await shared.currentToken()
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    /// 对外提供的异步函数
    /// - Returns: 当前有效的 Token
    ///
    /// - Author: GH
    public func currentToken() async -> String? {
        if let token = accessToken, !isRefreshing {
            // 如果 Token 已存在且不在刷新状态，则直接返回当前 Token
            return token
        } else {
            // 如果没有有效 Token 或没有在刷新状态刷新，则触发 Token 刷新流程
            return await refreshTokenIfNeeded()
        }
    }
    
    /// 检查是否需要刷新 Token，并根据需要启动刷新流程
    /// - Returns: 新 Token(String)
    ///
    /// - Author: GH
    private func refreshTokenIfNeeded() async -> String? {
        if isRefreshing {
            return await withCheckedContinuation { continuation in
                pendingRequests.append(continuation.resume)
            }
        } else {
            // 标记开始刷新 Token
            isRefreshing = true
            
            // 执行 Token 刷新操作
            let newToken = await refreshToken()
            accessToken = newToken
            
            // 通知所有等待的请求
            for request in pendingRequests {
                request(newToken)
            }
            pendingRequests.removeAll()
            
            // 更新 Token 并标记刷新完成
            isRefreshing = false
            return newToken
        }
    }
    
    /// Token 刷新
    /// - Returns: 新 Token
    ///
    /// - Author: GH
    private func refreshToken() async -> String {
        // Token 刷新的实现代码
        return ""
    }
    
    /// 调用 Keychain Manager 的方法
    /// - Parameter data: JSON 实例，会将 data 中 accessToken 字段提取并保存
    ///
    /// - Author: GH
    public static func saveAccessToken(_ data: JSON) {
        if let accessToken = data[ModuleConfig.shared.accessTokenKey].string {
            KeychainManager.shared.saveAccessTokenToKeychain(accessToken)
#if DEBUG
            print("Access Token: \(accessToken)")
            print("---Saved successfully!---")
#endif
        }
    }
    /// 调用 Keychain Manager 的方法
    /// - Parameter data: JSON 实例，会将 data 中 refreshToken 字段提取并保存
    ///
    /// - Author: GH
    public static func saveRefreshToken(_ data: JSON) {
        if let refreshToken = data[ModuleConfig.shared.refreshTokenKey].string {
            KeychainManager.shared.saveRefreshTokenToKeychain(refreshToken)
#if DEBUG
            print("Refresh Token: \(refreshToken)")
            print("---Saved successfully!---")
#endif
        }
    }

    /// 发送 Device Token 至后端
    ///
    /// - Author: GH
    public func bindingDeviceToken(_ token: String) {
        // 实现发送设备令牌至后端的代码
    }
}

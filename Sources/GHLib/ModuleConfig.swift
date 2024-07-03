//
//  ModuleConfig.swift
//  CoreModule
//
//  Created by GH on 7/3/24.
//

import Moya
import Foundation

public class ModuleConfig {
    public static let shared = ModuleConfig()
    private init() {}
    
    /// 网络请求超时时间，默认 10 秒
    public var timeoutInterval: TimeInterval = 10

    /// 存储 Access Token 的 Key 名，默认 "AccessToken"
    public var tokenStorageKey: String = "AccessToken"
    
    /// 存储 Refresh Token 的 Key 名，默认 "RefreshToken"
    public var refreshTokenStorageKey: String = "RefreshToken"
    
    /// 存储 UUID 的 Key 名，默认 "UUID"
    public var uuidStorageKey: String = "UUID"
    
    /// 非对称加密的密钥大小，默认 2048 位
    public var keySize: Int = 2048
    
    /// 非对称加密算法，默认 RSA + OAEP SHA-1 填充模式
    public var encryptionAlgorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA1
    
    /// Toast 显示时长，默认 2 秒
    public var toastDisplayDuration: TimeInterval = 2.0
    
    /// JSON 中检测 Access Token 的键名，默认 "accessToken"
    public var accessTokenKey: String = "accessToken"
    
    /// JSON 中检测 Refresh Token 的键名，默认 "refreshToken"
    public var refreshTokenKey: String = "refreshToken"
    
    /// 重置所有配置为默认值
    ///
    /// - Author: GH
    public func resetConfig() {
        self.timeoutInterval = 10
        self.tokenStorageKey = "AccessToken"
        self.refreshTokenStorageKey = "RefreshToken"
        self.uuidStorageKey = "UUID"
        self.keySize = 2048
        self.encryptionAlgorithm = .rsaEncryptionOAEPSHA1
        self.toastDisplayDuration = 2.0
        self.accessTokenKey = "accessToken"
        self.refreshTokenKey = "refreshToken"
    }
}

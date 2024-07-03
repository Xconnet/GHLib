//
//  Keychain.swift
//  CoreModule
//
//  Created by GH on 7/2/24.
//

import KeychainSwift

public class KeychainManager {
    public static let shared = KeychainManager()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    /// 保存 Access Token 至 Keychain
    /// - Parameter accessToken: accessToken(String)
    ///
    /// - Author: GH
    public func saveAccessTokenToKeychain(_ accessToken: String) {
        keychain.set(accessToken, forKey: ModuleConfig.shared.tokenStorageKey)
    }
    
    /// 保存 Refresh Token 至 Keychain
    /// - Parameter refreshToken: refreshToken(String)
    ///
    /// - Author: GH
    public func saveRefreshTokenToKeychain(_ refreshToken: String) {
        keychain.set(refreshToken, forKey: ModuleConfig.shared.refreshTokenStorageKey)
    }
    
    /// 从 Keychain 中读取 Access Token
    /// - Returns: accessToken(String)
    ///
    /// - Author: GH
    public func getAccessTokenFromKeychain() -> String? {
        return keychain.get(ModuleConfig.shared.tokenStorageKey)
    }
    
    /// 从 Keychain 中读取 Refresh Token
    /// - Returns: refreshToken(String)
    ///
    /// - Author: GH
    public func getRefreshTokenFromKeychain() -> String? {
        return keychain.get(ModuleConfig.shared.refreshTokenStorageKey)
    }
    
    /// 从 Keychain 中删除 Token
    ///
    /// - Author: GH
    public func deleteToken() {
        keychain.delete(ModuleConfig.shared.tokenStorageKey)
        keychain.delete(ModuleConfig.shared.refreshTokenStorageKey)
    }
    
    /// 保存 Device Token 至 Keychain
    /// - Parameter deviceToken: 设备令牌 (String)
    ///
    /// - Author: GH
    public func saveDeviceTokenToKeychain(_ deviceToken: String) {
        keychain.set(deviceToken, forKey: "DeviceToken")
    }
    
    /// 从 Keychain 中读取 Device Token
    /// - Returns: 设备令牌 (String)
    ///
    /// - Author: GH
    public func getDeviceTokenFromKeychain() -> String? {
        return keychain.get("DeviceToken")
    }
    
    /// 从 Keychain 中删除 Device Token
    ///
    /// - Author: GH
    public func deleteDeviceToken() {
        keychain.delete("DeviceToken")
    }
    
    /// 保存 UUID 至 Keychain
    /// - Parameter UUID: UUID 字符串
    ///
    /// - Author: GH
    public func saveUUID(_ UUID: String) {
        keychain.set(UUID, forKey: ModuleConfig.shared.uuidStorageKey)
    }
    
    /// 从 Keychain 中读取 UUID
    /// - Returns: UUID 字符串
    ///
    /// - Author: GH
    public func getUUID() -> String? {
        return keychain.get(ModuleConfig.shared.uuidStorageKey)
    }
    
    /// 从 Keychain 中删除 UUID
    ///
    /// - Author: GH
    public func deleteUUID() {
        keychain.delete(ModuleConfig.shared.uuidStorageKey)
    }
}

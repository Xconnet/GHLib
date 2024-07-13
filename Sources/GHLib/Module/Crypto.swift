//
//  Crypto.swift
//  CoreModule
//
//  Created by GH on 7/2/24.
//

import Foundation
import CryptoSwift

public class CryptoManager {
    public static let shared = CryptoManager()
    private init() {}
    
    /// 非对称密钥生成函数
    /// - Parameters:
    ///   - publicTag: 公钥标识
    ///   - privateTag: 私钥标识
    /// - Returns: 公钥与私钥
    ///
    /// - Author: GH
    public static func generateKeyPair(publicTag: String, privateTag: String) -> (publicKey: SecKey?, privateKey: SecKey?) {
        // 使用配置中的密钥大小
        let keySize = ModuleConfig.shared.keySize
        
        // 私钥参数
        let privateKeyParameters: [String: Any] = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privateTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: keySize
        ]
        
        // 生成私钥
        var error: Unmanaged<CFError>?
        
        guard let privateKey = SecKeyCreateRandomKey(privateKeyParameters as CFDictionary, &error) else {
            print("Failed to generate private key: \((error?.takeRetainedValue()) as Error?)")
            return (nil, nil)
        }
        
        // 由私钥创建公钥
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("Failed to extract public key from private key")
            return (nil, nil)
        }
        
        return (publicKey, privateKey)
    }
    
    /// 加载本地公钥
    /// - Parameter pemFileName: pem 文件名
    /// - Returns: SecKey 类型公钥
    ///
    /// - Author: GH
    public static func loadPublicKey(from pemFileName: String) -> SecKey? {
        // 尝试从应用的 bundle 中加载指定名称的 PEM 文件，并读取里面的字符
        guard let pemFilepath = Bundle.main.path(forResource: pemFileName, ofType: "pem"),
              let pemString = try? String(contentsOfFile: pemFilepath) else {
            print("Failed to load PEM file")
            return nil
        }
        
        // 从 PEM 字符串中移除标头、标尾和换行符，留下 Base64 编码的公钥部分
        let base64String = pemString
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "\r\n", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 将其转换为 data
        guard let data = Data(base64Encoded: base64String) else {
            print("Failed to decode base64")
            return nil
        }
        
        // 定义创建公钥所需的参数
        let options: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic
        ]
        
        var error: Unmanaged<CFError>?
        
        // 使用 Data 生成 SecKey
        guard let publicKey = SecKeyCreateWithData(data as CFData, options as CFDictionary, &error) else {
            print("Failed to create public key: \(error?.takeRetainedValue() as Error?)")
            return nil
        }
        
        return publicKey
    }
    
    /// 使用公钥加密`Data`
    /// - Parameters:
    ///   - data: 待加密数据
    ///   - publicKey: 公钥
    /// - Returns: 密文
    ///
    /// - Author: GH
    public func encrypt(data: Data, with publicKey: SecKey) -> Data? {
        // 使用配置中的加密算法
        let algorithm: SecKeyAlgorithm = ModuleConfig.shared.encryptionAlgorithm
        
        // 检查公钥是否支持所选算法
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            print("Algorithm not supported.")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        
        // 使用上述的公钥、加密算法与传入的数据进行加密
        guard let cipherData = SecKeyCreateEncryptedData(publicKey, algorithm, data as CFData, &error) else {
            if let error = error {
                print("Encryption error: \(error.takeRetainedValue())")
            }
            return nil
        }
        return cipherData as Data
    }
    
    /// 使用公钥加密`String`，将调用公钥加密数据函数
    /// - Parameters:
    ///   - string: 待加密字符串
    ///   - publicKey: 公钥
    /// - Returns: 密文
    ///
    /// - Author: GH
    public func encrypt(string: String, with publicKey: SecKey) -> Data? {
        // 首先尝试将字符串转换为 Data
        guard let data = string.data(using: .utf8) else {
            print("Error: Unable to convert string to Data")
            return nil
        }
        
        // 使用已有的 encrypt(data, with) 方法进行加密
        return encrypt(data: data, with: publicKey)
    }
    
    /// 生成特定长度的随机字符串
    /// - Parameter length: 长度
    /// - Returns: 随机字符串
    ///
    /// - Author: GH
    public func generateRandomString(_ length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    
    /// 生成基于 HMAC-SHA-256 的消息认证码
    /// - Parameters:
    ///   - message: 待加密的数据
    ///   - secret: 密钥
    /// - Returns: 密文
    ///
    /// - Author: GH
    public func hmacSHA256(_ message: String, secret: String) -> String? {
        do {
            // variant: HMAC-SHA-256 哈希函数
            // key: 将密钥转为字节数组
            let hmac = try HMAC(key: secret.bytes, variant: .sha2(.sha256)).authenticate(Array(message.utf8))
            
            // 将 HMAC 计算结果转换为 Data 对象
            let hmacData = Data(hmac)
            
            // 使用 Data 扩展方法获取 URL 安全的 Base64 编码
            let base64UrlEncoded = hmacData.base64UrlEncodedString()
            
            return base64UrlEncoded
        } catch {
            print("HMAC generation error: \(error)")
            return nil
        }
    }
}

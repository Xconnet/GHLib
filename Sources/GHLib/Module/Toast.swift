//
//  Toast.swift
//  CoreModule
//
//  Created by GH on 7/2/24.
//

import Async
import AlertToast
import Foundation

public class ToastManager: ObservableObject {
    public static let shared = ToastManager()
    private init() {}
    
    @Published public var showToast = false
    @Published public var showLoadingToast = false
    @Published public var showHUDToast = false
    @Published public var showBannerToast = false
    
    public var toast = AlertToast(type: .regular)
    public var loading = AlertToast(type: .loading, title: "Loading...")
    public var hud = AlertToast(displayMode: .hud, type: .complete(.green))
    public var banner = AlertToast(displayMode: .banner(.pop), type: .complete(.green))
    
    /// 显示加载中的 Toast
    /// - Parameter title: Toast 的标题
    ///
    /// - Author: GH
    public func loadingToast() {
        Async.main {
            self.showLoadingToast = true
        }
    }
    
    public func completeToast(title: String, subTitle: String? = nil) {
        Async.main {
            self.toast = AlertToast(type: .complete(.green), title: title, subTitle: subTitle)
            self.showToast = true
        }
    }
    
    /// 显示错误类型的 Toast
    /// - Parameters:
    ///   - title: Toast 的标题
    ///   - subTitle: Toast 的副标题，可选
    ///
    /// - Author: GH
    public func errorToast(title: String, subTitle: String? = nil) {
        Async.main {
            self.toast = AlertToast(type: .error(.red), title: title, subTitle: subTitle)
            self.showToast = true
        }
    }
    
    public func HUDToast(title: String, subTitle: String? = nil) {
        Async.main {
            self.hud = AlertToast(
                displayMode: .hud,
                type: .complete(.green),
                title: title,
                subTitle: subTitle
            )
            self.showHUDToast = true
        }
    }
    
    /// 显示横幅类型的 Toast
    /// - Parameters:
    ///   - title: Toast 的标题
    ///   - subTitle: Toast 的副标题，可选
    ///
    /// - Author: GH
    public func bannerToast(title: String, subTitle: String? = nil) {
        Async.main {
            self.banner = AlertToast(
                displayMode: .banner(.pop),
                type: .complete(.green),
                title: title,
                subTitle: subTitle
            )
            self.showBannerToast = true
        }
    }
    
    public func hideLoadingToast() {
        Async.main {
            self.showLoadingToast = false
        }
    }
}

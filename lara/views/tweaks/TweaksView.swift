//
//  TweaksView.swift
//  lara
//
//  Created by lunginspector on 5/3/26.
//

import SwiftUI

struct TweaksView: View {
    @AppStorage("logsdisplaymode") private var selectedlogsdisplaymode: logsdisplaymode = .toolbar
    @ObservedObject var mgr: laramgr
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HeaderLabel(text: "主屏幕", icon: "house")) {
                    NavigationLink("RemoteCall 自定义", destination: RemoteView(mgr: mgr))
                        .disabled(!mgr.rcready)
                    NavigationLink("DarkBoard", destination: DarkBoardView())
                        .disabled(true)
                    NavigationLink("液态玻璃", destination: LiquidGlassView())
                        .disabled(!mgr.vfsready)
                    if doubleSystemVersion() < 26.0 {
                        NavigationLink("主屏幕自定义", destination: SpringBoardView())
                            .disabled(!mgr.vfsready)
                    }
                }
                
                Section(header: HeaderLabel(text: "锁定屏幕", icon: "lock")) {
                    NavigationLink("密码主题", destination: PasscodeView(mgr: mgr))
                        .disabled(!mgr.sbxready)
                }
                
                Section(header: HeaderLabel(text: "应用", icon: "app")) {
                    NavigationLink("卡片覆盖", destination: CardView())
                        .disabled(!mgr.vfsready)
                    NavigationLink("3 应用绕过", destination: AppsView())
                        .disabled(!mgr.sbxready)
                    NavigationLink("移除黑名单", destination: WhitelistView())
                        .disabled(!mgr.sbxready)
                    NavigationLink("JIT 启用器", destination: JitView())
                        .disabled(!mgr.sbxready)
                }
                
                Section(header: HeaderLabel(text: "用户界面", icon: "eye")) {
                    NavigationLink("dirtyZero", destination: dirtyZeroView())
                        .disabled(!mgr.vfsready)
                    NavigationLink("MobileGestalt", destination: GestaltView(mgr: laramgr()))
                        .disabled(!mgr.sbxready)
                    NavigationLink("字体覆盖", destination: FontPicker(mgr: mgr))
                        .disabled(!mgr.vfsready)
                    NavigationLink("全局改色工具", destination: SystemColor(mgr: mgr))
                        .disabled(!mgr.sbxready || !mgr.vfsready)
                }
                
                Section(header: HeaderLabel(text: "系统", icon: "gear")) {
                    NavigationLink("VarClean", destination: VarCleanView())
                        .disabled(!mgr.sbxready)
                    NavigationLink("自定义覆盖", destination: CustomView(mgr: mgr))
                        .disabled(!mgr.vfsready)
                }
                
                NavigationLink("额外工具", destination: ToolsView())
            }
            .disabled(!mgr.dsready)
            .navigationTitle("调整")
            .toolbar {
                if selectedlogsdisplaymode == .toolbar {
                    Button(action: {
                        mgr.showLogs.toggle()
                    }) {
                        Image(systemName: "terminal")
                    }
                }
            }
        }
    }
}

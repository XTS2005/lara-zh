//
//  ShowHiddenIconsView.swift
//  lara
//

import SwiftUI

struct ShowHiddenIconsView: View {
    @ObservedObject var mgr: laramgr

    private let key = "SBIconVisibility"
    private let path = fileloc.globalprefs.rawValue

    @State private var isEnabled = false
    @State private var isLoading = false
    @State private var status: String?
    @State private var confirmRebuildDB = false

    var body: some View {
        List {
            Section(
                header: HeaderLabel(text: "主屏幕", icon: "app.badge"),
                footer: Text("灵感来自 Nugget 的\"Show Hidden Icons on Home Screen\"调整。将 SBIconVisibility 写入 GlobalPreferences。可能需要在重建 SpringBoard 的 Application State DB 后才能生效。")
            ) {
                Toggle("显示隐藏图标", isOn: Binding(
                    get: { isEnabled },
                    set: { setEnabled($0) }
                ))
                .disabled(isLoading || !canWrite)

                HStack {
                    Text("偏好设置")
                    Spacer()
                    Text(isEnabled ? "已启用" : "已禁用")
                        .foregroundColor(isEnabled ? .green : .secondary)
                        .monospaced()
                }
            }

            Section(
                header: HeaderLabel(text: "操作", icon: "wrench.and.screwdriver"),
                footer: Text("刷新仅从 GlobalPreferences 重新加载当前的 SBIconVisibility 值。不会重建 SpringBoard 缓存。")
            ) {
                Button {
                    loadState()
                } label: {
                    if isLoading {
                        HStack {
                            Text("正在刷新...")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        Text("刷新偏好设置状态")
                    }
                }
                .disabled(isLoading || !canWrite)

                HStack {
                    Button(role: .destructive) {
                        reset()
                    } label: {
                        Text("移除偏好设置")
                    }
                    .disabled(isLoading || !canWrite)

                    Spacer()

                    Button {
                        Alertinator.shared.alert(
                            title: "移除偏好设置",
                            body: "从 GlobalPreferences 中删除 SBIconVisibility 键，而非写入 false。这将恢复默认偏好设置值。如果 SpringBoard 已缓存旧状态，您可能仍需重建 Application State DB 并重启。"
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .frame(width: 24, height: 22)
                    }
                    .buttonStyle(.plain)
                }

                HStack {
                    Button(role: .destructive) {
                        confirmRebuildDB = true
                    } label: {
                        Text("重建 Application State DB")
                    }
                    .disabled(isLoading || !canWrite)

                    Spacer()

                    Button {
                        Alertinator.shared.alert(
                            title: "重建 Application State DB",
                            body: "清除 SpringBoard 的 applicationState.db、applicationState.db-wal 和 applicationState.db-shm，以便 SpringBoard 重建它们。应用后请重启。注销可能导致主屏幕黑屏，且部分小组件配置可能丢失。"
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .frame(width: 24, height: 22)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("显示隐藏图标")
        .onAppear {
            loadState()
        }
        .alert("显示隐藏图标", isPresented: .constant(status != nil)) {
            Button("确定") { status = nil }
        } message: {
            Text(status ?? "")
        }
        .alert("重建 Application State DB？", isPresented: $confirmRebuildDB) {
            Button("取消", role: .cancel) {}
            Button("重建", role: .destructive) {
                rebuildApplicationStateDB()
            }
        } message: {
            Text("此操作与 Nugget 的\"Rebuild SpringBoard Application State DB\"选项一致。它将 SpringBoard 的 applicationState.db 替换为空文件，以便 SpringBoard 可以重建。应用后应重启设备。注销可能导致主屏幕黑屏。重建此 DB 还可能重置部分应用/小组件状态，包括小组件配置。仅在您接受此风险时继续。")
        }
    }

    private var canWrite: Bool {
        mgr.sbxready || mgr.vfsready
    }

    private func loadState() {
        guard canWrite else {
            status = "沙盒逃逸或 VFS 未就绪。"
            return
        }

        isLoading = true
        defer { isLoading = false }

        let result = mgr.getplistvalue(path: path, key: key)
        if result.ok, let value = result.value as? Bool {
            isEnabled = value
        } else {
            isEnabled = false
        }
    }

    private func setEnabled(_ enabled: Bool) {
        guard canWrite else {
            status = "沙盒逃逸或 VFS 未就绪。"
            return
        }

        isLoading = true
        defer { isLoading = false }

        let result = mgr.setplistvalue(
            path: path,
            key: (key, enabled ? true : nil),
            force: true
        )

        if result.ok {
            isEnabled = enabled
            status = enabled
                ? "SBIconVisibility 已启用。如果没有可见效果，可能需要重建 SpringBoard 的 Application State DB，然后重启设备。"
                : "SBIconVisibility 偏好设置已移除。如果没有可见效果，请重建 SpringBoard 的 Application State DB，然后重启设备。"
        } else {
            status = result.message
            loadState()
        }
    }

    private func reset() {
        setEnabled(false)
    }

    private func rebuildApplicationStateDB() {
        guard canWrite else {
            status = "沙盒逃逸或 VFS 未就绪。"
            return
        }

        isLoading = true
        defer { isLoading = false }

        let dbPaths = [
            "/var/mobile/Library/FrontBoard/applicationState.db",
            "/var/mobile/Library/FrontBoard/applicationState.db-wal",
            "/var/mobile/Library/FrontBoard/applicationState.db-shm",
        ]

        var failures: [String] = []
        for dbPath in dbPaths {
            let result = mgr.lara_overwritefile(target: dbPath, data: Data())
            if !result.ok {
                failures.append("\(dbPath): \(result.message)")
            }
        }

        if failures.isEmpty {
            status = "Application State DB 已清除。请立即重启设备。不要依赖注销；可能导致主屏幕黑屏。部分小组件配置可能丢失。"
        } else {
            status = failures.joined(separator: "\n")
        }
    }
}

#Preview {
    NavigationStack {
        ShowHiddenIconsView(mgr: laramgr.shared)
    }
}

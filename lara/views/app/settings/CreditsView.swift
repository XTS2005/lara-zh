//
//  CreditsView.swift
//  lara
//
//  Created by lunginspector on 5/9/26.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        NavigationStack {
            List {
                LinkCreditCell(name: "roooot", description: "主要开发者", url: "https://github.com/rooootdev") {
                    LinkCreditIcon(url: "https://github.com/rooootdev.png")
                }
                LinkCreditCell(name: "wh1te4ever", description: "制作了 darksword-kexploit-fun", url: "https://github.com/wh1te4ever") {
                    LinkCreditIcon(url: "https://github.com/wh1te4ever.png")
                }
                LinkCreditCell(name: "Duy Tran", description: "各种 RemoteCall 相关的改进和功能", url: "https://github.com/khanhduytran0") {
                    LinkCreditIcon(url: "https://github.com/khanhduytran0.png")
                }
                LinkCreditCell(name: "AppInstalleriOS", description: "帮助我处理偏移量和许多其他事情", url: "https://github.com/AppInstalleriOSGH") {
                    LinkCreditIcon(url: "https://github.com/AppInstalleriOSGH.png")
                }
                LinkCreditCell(name: "jailbreak.party", description: "dirtyZero 调整", url: "https://github.com/jailbreakdotparty") {
                    LinkCreditIcon(url: "https://github.com/jailbreakdotparty.png")
                }
                LinkCreditCell(name: "lunginspector", description: "前端重写", url: "https://github.com/lunginspector") {
                    LinkCreditIcon(url: "https://github.com/lunginspector.png")
                }
                LinkCreditCell(name: "Jurre", description: "EditorView、PocketPoster 助手、各种改进", url: "https://github.com/jurre111") {
                    LinkCreditIcon(url: "https://github.com/jurre111.png")
                }
                LinkCreditCell(name: "neon", description: "注销脚本", url: "https://github.com/neonmodder123") {
                    LinkCreditIcon(url: "https://github.com/neonmodder123.png")
                }
                LinkCreditCell(name: "Skadz", description: "注销方法", url: "https://github.com/skadz108") {
                    LinkCreditIcon(url: "https://github.com/skadz108.png")
                }
                LinkCreditCell(name: "hxhlb", description: "各种 Bug 修复", url: "https://github.com/hxhlb") {
                    LinkCreditIcon(url: "https://github.com/hxhlb.png")
                }
                LinkCreditCell(name: "leminlimez", description: "各种 Cowabunga 调整", url: "https://github.com/leminlimez") {
                    LinkCreditIcon(url: "https://github.com/leminlimez.png")
                }
                LinkCreditCell(name: "浮梦往事", description: "完成了汉化工作。\n如有漏翻或翻译不当之处，请务必告知！", url: "https://www.coolapk.com/u/30819340") {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                        Text("汉")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("致谢")
        }
    }
}

// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code has been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓

import SwiftUI

class StatusBarPlaybackManager: ObservableObject {
    
    @AppStorage("showMenuBarPlaybackControls") var showMenuBarPlaybackControls: Bool = false
    
    private var playerManager: PlayerManager
    private var statusBarItem: NSStatusItem
    
    init(playerManager: PlayerManager) {
        self.playerManager = playerManager
        
        // Playback buttons in meu bar
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusBarItem.isVisible = self.showMenuBarPlaybackControls
        self.updateStatusBarPlaybackItem(playerAppIsRunning: playerManager.isRunning)
        
        let contextMenu = NSMenu()
        contextMenu.addItem(
            withTitle: "Settings...",
            action: #selector(AppDelegate.openSettings),
            keyEquivalent: ""
        )
        contextMenu.addItem(
            .separator()
        )
        contextMenu.addItem(
            withTitle: "Quit",
            action: #selector(NSApplication.terminate),
            keyEquivalent: ""
        )
        
        self.statusBarItem.menu = contextMenu
    }

    func toggleStatusBarVisibility() {
        statusBarItem.isVisible = self.showMenuBarPlaybackControls
    }
    
    @objc func updateStatusBarPlaybackItem(playerAppIsRunning: Bool) {
        let menuBarView = HStack {
            Button(action: playerManager.previousTrack){
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .frame(width: 9, height: 9)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
            .disabled(!playerAppIsRunning)
            .opacity(playerAppIsRunning ? 1.0 : 0.8)
            
            PlayPauseButton(buttonSize: 14)
                .environmentObject(playerManager)
                .disabled(!playerAppIsRunning)
                .opacity(playerAppIsRunning ? 1.0 : 0.8)
            
            Button(action: playerManager.nextTrack) {
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .frame(width: 9, height: 9)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
            .disabled(!playerAppIsRunning)
            .opacity(playerAppIsRunning ? 1.0 : 0.8)
        }
        
        let iconView = NSHostingView(rootView: menuBarView)
        iconView.frame = NSRect(x: 0, y: 1, width: 70, height: 20)
        
        if let button = self.statusBarItem.button {
            button.subviews.forEach { $0.removeFromSuperview() }
            button.addSubview(iconView)
            button.frame = iconView.frame
        }
    }
}


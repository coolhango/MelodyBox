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
import AppKit

class MiniPlayerWindow: NSWindow {
    
    @AppStorage("miniPlayerType") var miniPlayerType: MiniPlayerType = .minimal
    
    init() {
        super.init(
            contentRect: NSRect(x: 10, y: 0, width: 300, height: 145),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.isMovableByWindowBackground = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenNone]
        self.isReleasedWhenClosed = false
        self.backgroundColor = NSColor.clear
        self.hasShadow = true
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()
        
        menu.addItem(withTitle: "Hide window", action: #selector(hideWindow(_:)), keyEquivalent: "")

        let customizeMenuItem = NSMenuItem(title: "Window style", action: nil, keyEquivalent: "")
        let customizeMenu = NSMenu()
        customizeMenu
            .addItem(withTitle: "Full", action: #selector(setFullPlayer(_:)), keyEquivalent: "")
            .state = self.miniPlayerType == .full ? .on : .off
        customizeMenu
            .addItem(withTitle: "Minimal", action: #selector(setAlbumArtPlayer(_:)), keyEquivalent: "")
            .state = self.miniPlayerType == .minimal ? .on : .off
        customizeMenuItem.submenu = customizeMenu
        
        menu.addItem(customizeMenuItem)
        menu.addItem(withTitle: "Settings...", action: #selector(settings(_:)), keyEquivalent: "")

        NSMenu.popUpContextMenu(menu, with: event, for: self.contentView!)
    }
    
    override var canBecomeKey: Bool {
        return true
    }

    @objc func setFullPlayer(_ sender: Any) {
        miniPlayerType = .full
        NSApplication.shared.sendAction(#selector(AppDelegate.setupMiniPlayer), to: nil, from: nil)
    }

    @objc func setAlbumArtPlayer(_ sender: Any) {
        miniPlayerType = .minimal
        NSApplication.shared.sendAction(#selector(AppDelegate.setupMiniPlayer), to: nil, from: nil)
    }
    
    @objc func hideWindow(_ sender: Any?) {
        NSApplication.shared.sendAction(#selector(AppDelegate.toggleMiniPlayer), to: nil, from: nil)
    }
    
    @objc func settings(_ sender: Any?) {
        NSApplication.shared.sendAction(#selector(AppDelegate.openMiniPlayerAppearanceSettings), to: nil, from: nil)
    }
}

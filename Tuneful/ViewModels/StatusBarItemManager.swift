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

class StatusBarItemManager: ObservableObject {
    
    @AppStorage("menuBarItemWidth") var menuBarItemWidth: Double = 150
    @AppStorage("statusBarIcon") var statusBarIcon: StatusBarIcon = .albumArt
    @AppStorage("trackInfoDetails") var trackInfoDetails: StatusBarTrackDetails = .artistAndSong
    @AppStorage("connectedApp") var connectedApp: ConnectedApps = ConnectedApps.spotify
    @AppStorage("showStatusBarTrackInfo") var showStatusBarTrackInfo: ShowStatusBarTrackInfo = .always
    @AppStorage("scrollingTrackInfo") var scrollingTrackInfo: Bool = true
    
    public func getMenuBarView(track: Track, playerAppIsRunning: Bool, isPlaying: Bool) -> NSView {
        let title = self.getStatusBarTrackInfo(track: track, playerAppIsRunning: playerAppIsRunning, isPlaying: isPlaying)
        let image = self.getImage(albumArt: track.albumArt, playerAppIsRunning: playerAppIsRunning)
        
        let titleWidth = title.stringWidth(with: Constants.StatusBar.marqueeFont)
        
        var menuBarItemWidth = titleWidth == 0
            ? Constants.StatusBar.imageWidth
            : (self.menuBarItemWidth > titleWidth  ? titleWidth + 5 : self.menuBarItemWidth + 5)
        if self.statusBarIcon != .hidden && titleWidth != 0 {
            menuBarItemWidth += Constants.StatusBar.imageWidth
        }
        
        let mainView = HStack(spacing: 7) {
            if self.statusBarIcon != .hidden || titleWidth == 0 { // Should display icon when there is no menubar text
                Image(nsImage: image)
            }
            
            if scrollingTrackInfo && titleWidth != 0 {
                MarqueeText(text: title, leftFade: 0.0, rightFade: 0.0, startDelay: 0, animating: isPlaying)
            }
            
            if !scrollingTrackInfo && titleWidth != 0 {
                Text(title)
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .regular))
                    .offset(x: -2.5) // Prevent small jumps when toggling between scrolling on and off
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        
        let menuBarView = NSHostingView(rootView: mainView)
        menuBarView.frame = NSRect(x: 1, y: 1, width: menuBarItemWidth, height: 20)
        return menuBarView
    }
    
    // MARK: - Private
    
    private func getStatusBarTrackInfo(track: Track, playerAppIsRunning: Bool, isPlaying: Bool) -> String {
        if self.showStatusBarTrackInfo == .never {
            return ""
        }
        
        if self.showStatusBarTrackInfo == .whenPlaying && !isPlaying {
            return ""
        }
        
        if !playerAppIsRunning {
            return "Open \(connectedApp.rawValue)"
        }
        
        let trackTitle = track.title
        let trackArtist = track.artist
        
        var trackInfo = ""
        switch trackInfoDetails {
        case .artistAndSong:
            // In some cases either of these is missing (e.g. podcasts) which would result in "• PodcastTitle"
            if !trackArtist.isEmpty && !trackTitle.isEmpty {
                trackInfo = "\(trackArtist) • \(trackTitle)"
            } else if !trackArtist.isEmpty {
                trackInfo = "\(trackArtist)"
            } else if !trackTitle.isEmpty {
                trackInfo = "\(trackTitle)"
            }
        case .artist:
            trackInfo = "\(trackArtist)"
        case .song:
            trackInfo = "\(trackTitle)"
        }
        
        return trackInfo
    }
    
    private func getImage(albumArt: NSImage, playerAppIsRunning: Bool) -> NSImage {
        if statusBarIcon == .albumArt && playerAppIsRunning {
            return albumArt.roundImage(withSize: NSSize(width: 18, height: 18), radius: 4.0)
        }
        
        return NSImage(systemSymbolName: "music.quarternote.3", accessibilityDescription: "MelodyBox")!
    }
}

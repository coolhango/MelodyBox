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
import Settings

struct MenuBarSettingsView: View {
    
    @AppStorage("menuBarItemWidth") var menuBarItemWidthAppStorage: Double = 150
    @AppStorage("statusBarIcon") var statusBarIconAppStorage: StatusBarIcon = .albumArt
    @AppStorage("trackInfoDetails") var trackInfoDetailsAppStorage: StatusBarTrackDetails = .artistAndSong
    @AppStorage("showStatusBarTrackInfo") var showStatusBarTrackInfoAppStorage: ShowStatusBarTrackInfo = .always
    @AppStorage("showMenuBarPlaybackControls") var showMenuBarPlaybackControlsAppStorage: Bool = false
    @AppStorage("hideMenuBarItemWhenNotPlaying") var hideMenuBarItemWhenNotPlayingAppStorage: Bool = false
    @AppStorage("scrollingTrackInfo") var scrollingTrackInfoAppStorage: Bool = true
    
    // A bit of a hack, binded AppStorage variable doesn't refresh UI, first we read the app storage this way
    // and @AppStorage variable  is updated whenever the state changes using .onChange()
    @State var menuBarItemWidth: Double
    @State var statusBarIcon: StatusBarIcon
    @State var trackInfoDetails: StatusBarTrackDetails
    @State var showStatusBarTrackInfo: ShowStatusBarTrackInfo
    @State var showMenuBarPlaybackControls: Bool
    @State var hideMenuBarItemWhenNotPlaying: Bool
    @State var scrollingTrackInfo: Bool
    
    init() {
        @AppStorage("menuBarItemWidth") var menuBarItemWidthAppStorage: Double = 150
        @AppStorage("statusBarIcon") var statusBarIconAppStorage: StatusBarIcon = .albumArt
        @AppStorage("trackInfoDetails") var trackInfoDetailsAppStorage: StatusBarTrackDetails = .artistAndSong
        @AppStorage("showStatusBarTrackInfo") var showStatusBarTrackInfoAppStorage: ShowStatusBarTrackInfo = .always
        @AppStorage("showMenuBarPlaybackControls") var showMenuBarPlaybackControlsAppStorage: Bool = false
        @AppStorage("hideMenuBarItemWhenNotPlaying") var hideMenuBarItemWhenNotPlayingAppStorage: Bool = false
        @AppStorage("scrollingTrackInfo") var scrollingTrackInfoAppStorage: Bool = true
        
        self.menuBarItemWidth = menuBarItemWidthAppStorage
        self.statusBarIcon = statusBarIconAppStorage
        self.trackInfoDetails = trackInfoDetailsAppStorage
        self.showStatusBarTrackInfo = showStatusBarTrackInfoAppStorage
        self.showMenuBarPlaybackControls = showMenuBarPlaybackControlsAppStorage
        self.hideMenuBarItemWhenNotPlaying = hideMenuBarItemWhenNotPlayingAppStorage
        self.scrollingTrackInfo = scrollingTrackInfoAppStorage
    }

    var body: some View {
        VStack {
            Settings.Container(contentWidth: 400) {
                
                Settings.Section(label: {
                    Text("Menu bar icon")
                }) {
                    Picker("", selection: $statusBarIcon) {
                        ForEach(StatusBarIcon.allCases, id: \.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                    .onChange(of: statusBarIcon) { _ in
                        self.statusBarIconAppStorage = statusBarIcon
                        
                        if statusBarIcon == .hidden && showStatusBarTrackInfo == .never {
                            showStatusBarTrackInfo = .whenPlaying
                        }
                        
                        self.sendTrackChangedNotification()
                    }
                    .pickerStyle(.menu)
                    .frame(width: 200)
                }
                
                
                Settings.Section(label: {
                    Text("Show song info in menu bar")
                }) {
                    Picker("", selection: $showStatusBarTrackInfo) {
                        ForEach(ShowStatusBarTrackInfo.allCases, id: \.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                    .onChange(of: showStatusBarTrackInfo) { _ in
                        self.showStatusBarTrackInfoAppStorage = showStatusBarTrackInfo
                        
                        if statusBarIcon == .hidden && showStatusBarTrackInfo == .never {
                            statusBarIcon = .appIcon
                        }
                        
                        self.sendTrackChangedNotification()
                    }
                    .pickerStyle(.menu)
                    .frame(width: 200)
                }
                
                Settings.Section(label: {
                    Text("Song info details")
                        .foregroundStyle(self.showStatusBarTrackInfo == .never ? .tertiary : .primary)
                }) {
                    Picker("", selection: $trackInfoDetails) {
                        ForEach(StatusBarTrackDetails.allCases, id: \.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                    .onChange(of: trackInfoDetails) { _ in
                        self.trackInfoDetailsAppStorage = trackInfoDetails
                        self.sendTrackChangedNotification()
                    }
                    .pickerStyle(.menu)
                    .frame(width: 200)
                    .disabled(self.showStatusBarTrackInfo == .never)
                }
                
                Settings.Section(label: {
                    Text("Song info width")
                        .foregroundStyle(self.showStatusBarTrackInfo == .never ? .tertiary : .primary)
                }) {
                    VStack(alignment: .center) {
                        Slider(value: $menuBarItemWidth, in: 100...300, step: 25) {
                            Text("")
                        } minimumValueLabel: {
                            Text("100")
                        } maximumValueLabel: {
                            Text("300")
                        }
                        .onChange(of: menuBarItemWidth) { _ in
                            self.menuBarItemWidthAppStorage = menuBarItemWidth
                            self.sendTrackChangedNotification()
                            NSHapticFeedbackManager.defaultPerformer.perform(NSHapticFeedbackManager.FeedbackPattern.levelChange, performanceTime: .now)
                        }
                        .frame(width: 200)
                        .disabled(self.showStatusBarTrackInfo == .never)
                        
                        Text("Width: \(Int(self.menuBarItemWidth)) pixels")
                            .foregroundStyle(self.showStatusBarTrackInfo == .never ? .tertiary : .primary)
                            .font(.callout)
                    }
                }
                
                Settings.Section(label: {
                    Text("Scrolling song info")
                }) {
                    Toggle(isOn: $scrollingTrackInfo) {
                        Text("")
                    }
                    .onChange(of: scrollingTrackInfo) { _ in
                        self.scrollingTrackInfoAppStorage = scrollingTrackInfo
                        self.sendTrackChangedNotification()
                    }
                    .toggleStyle(.switch)
                    .disabled(self.showStatusBarTrackInfo == .never)
                }
                
                Settings.Section(label: {
                    Text("Hide when music is not playing")
                }) {
                    Toggle(isOn: $hideMenuBarItemWhenNotPlaying) {
                        Text("")
                    }
                    .onChange(of: hideMenuBarItemWhenNotPlaying) { _ in
                        self.hideMenuBarItemWhenNotPlayingAppStorage = hideMenuBarItemWhenNotPlaying
                        self.sendTrackChangedNotification()
                    }
                    .toggleStyle(.switch)
                }
                
                Settings.Section(label: {
                    Text("Show player controls")
                }) {
                    Toggle(isOn: $showMenuBarPlaybackControls) {
                        Text("")
                    }
                    .onChange(of: showMenuBarPlaybackControls) { _ in
                        self.showMenuBarPlaybackControlsAppStorage = showMenuBarPlaybackControls
                        NSApplication.shared.sendAction(#selector(AppDelegate.menuBarPlaybackControls), to: nil, from: nil)
                    }
                    .toggleStyle(.switch)
                }
            }
        }
    }
    
    private func sendTrackChangedNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateMenuBarItem"), object: nil, userInfo: [:])
    }
}

struct MenuBarAppearanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarSettingsView()
            .previewLayout(.device)
            .padding()
    }
}

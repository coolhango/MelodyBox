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
import MediaPlayer

struct CompactMiniPlayerView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @AppStorage("miniPlayerBackground") var miniPlayerBackground: BackgroundType = .albumArt
    @State private var isShowingPlaybackControls = false
    
    private var imageSize: CGFloat = 140.0
    private var cornerRadius: CGFloat = 10.0
    private var playbackButtonSize: CGFloat = 15.0
    private var playPauseButtonSize: CGFloat = 25.0
    private weak var parentWindow: MiniPlayerWindow!
    
    init(parentWindow: MiniPlayerWindow) {
        self.parentWindow = parentWindow
    }

    var body: some View {
        ZStack {
            if miniPlayerBackground == .albumArt && playerManager.isRunning {
                Image(nsImage: playerManager.track.albumArt)
                    .resizable()
                    .scaledToFill()
                VisualEffectView(material: .popover, blendingMode: .withinWindow)
            }
            
            if !playerManager.isRunning {
                Text("Please open \(playerManager.name) to use MelodyBox")
                    .foregroundColor(.primary.opacity(0.4))
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .padding(.bottom, 20)
            } else {
                Image(nsImage: playerManager.track.albumArt)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(8)
                    .frame(width: self.imageSize, height: self.imageSize)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .dragWindowWithClick()
                    .gesture(
                        TapGesture(count: 2).onEnded {
                            self.playerManager.openMusicApp()
                        }
                    )

                HStack(spacing: 8) {
                    if playerManager.isLikeAuthorized() {
                        Button {
                            playerManager.toggleLoveTrack()
                        } label: {
                            Image(systemName: playerManager.isLoved ? "star.fill" : "star")
                                .font(.system(size: 14))
                                .foregroundColor(.primary.opacity(0.8))
                        }
                        .pressButtonStyle()
                    }
                    
                    Button(action: playerManager.previousTrack){
                        Image(systemName: "backward.end.fill")
                            .resizable()
                            .frame(width: self.playbackButtonSize, height: self.playbackButtonSize)
                            .animation(.easeInOut(duration: 2.0), value: 1)
                    }
                    .pressButtonStyle()
                    
                    PlayPauseButton(buttonSize: self.playPauseButtonSize)
                    
                    Button(action: playerManager.nextTrack) {
                        Image(systemName: "forward.end.fill")
                            .resizable()
                            .frame(width: self.playbackButtonSize, height: self.playbackButtonSize)
                            .animation(.easeInOut(duration: 2.0), value: 1)
                    }
                    .pressButtonStyle()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(VisualEffectView(material: .popover, blendingMode: .withinWindow))
                .cornerRadius(cornerRadius)
                .opacity(isShowingPlaybackControls ? 1 : 0)
            }
        }
        .frame(width: 155, height: 155)
        .onHover { _ in
            withAnimation(.linear(duration: 0.1)) {
                self.isShowingPlaybackControls.toggle()
            }
        }
        .overlay(
            NotificationView()
        )
        .if(miniPlayerBackground == .transparent || !playerManager.isRunning) { view in
            view.background(VisualEffectView(material: .underWindowBackground, blendingMode: .withinWindow))
        }
    }
}

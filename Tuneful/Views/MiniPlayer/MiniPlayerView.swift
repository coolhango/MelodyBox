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

struct MiniPlayerView: View {
    
    @AppStorage("miniPlayerBackground") var miniPlayerBackground: BackgroundType = .albumArt
    @EnvironmentObject var playerManager: PlayerManager
    
    private var imageSize: CGFloat = 140.0
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
                HStack(spacing: 0) {
                    Image(nsImage: playerManager.track.albumArt)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(8)
                        .frame(width: self.imageSize, height: self.imageSize)
                        .padding(.leading, 7)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .dragWindowWithClick()
                        .gesture(
                            TapGesture(count: 2).onEnded {
                                self.playerManager.openMusicApp()
                            }
                        )
                    
                    VStack(spacing: 7) {
                        Button(action: playerManager.openMusicApp) {
                            VStack {
                                Text(playerManager.track.title)
                                    .font(.body)
                                    .bold()
                                    .lineLimit(1)
                                
                                Text(playerManager.track.artist)
                                    .font(.body)
                                    .lineLimit(1)
                            }
                        }
                        .pressButtonStyle()
                        
                        PlaybackPositionView()
                        
                        HStack(spacing: 10) {
                            
                            Button(action: playerManager.previousTrack){
                                Image(systemName: "backward.end.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .animation(.easeInOut(duration: 2.0), value: 1)
                            }
                            .pressButtonStyle()
                            
                            PlayPauseButton(buttonSize: 35)
                            
                            Button(action: playerManager.nextTrack) {
                                Image(systemName: "forward.end.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .animation(.easeInOut(duration: 2.0), value: 1)
                            }
                            .pressButtonStyle()
                        }
                    }
                    .padding()
                    .opacity(0.8)
                }
            }
        }
        .frame(width: 310, height: 155)
        .overlay(
            NotificationView()
        )
        .if(miniPlayerBackground == .transparent || !playerManager.isRunning) { view in
            view.background(VisualEffectView(material: .underWindowBackground, blendingMode: .withinWindow))
        }
    }
}

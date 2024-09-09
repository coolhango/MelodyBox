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

struct PopoverView: View {
    
    @AppStorage("popoverBackground") var popoverBackground: BackgroundType = .albumArt
    @EnvironmentObject var playerManager: PlayerManager
    
    var body: some View {
        
        ZStack {
            if popoverBackground == .albumArt && playerManager.isRunning {
                Image(nsImage: playerManager.track.albumArt)
                    .resizable()
                VisualEffectView(material: .popover, blendingMode: .withinWindow)
            }
            
            if !playerManager.isRunning {
                Text("Please open \(playerManager.name) to use MelodyBox")
                    .foregroundColor(.primary.opacity(Constants.Opacity.secondaryOpacity))
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack(spacing: 0) {
                    // Media details
                    VStack(spacing: 0) {
                        
                        Button(action: playerManager.openMusicApp) {
                            AlbumArtView(imageSize: 185)
                                .padding(.top, 12)
                        }
                        .pressButtonStyle()

                        // Track details
                        Button(action: playerManager.openMusicApp) {
                            VStack(alignment: .center) {
                                Text(playerManager.track.title)
                                    .foregroundColor(.primary.opacity(Constants.Opacity.primaryOpacity))
                                    .font(.system(size: 15, weight: .bold))
                                    .lineLimit(1)
                                Text(playerManager.track.artist)
                                    .foregroundColor(.primary.opacity(Constants.Opacity.primaryOpacity2))
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                            }
                            .frame(width: 180, height: 65, alignment: .center)
                            .opacity(0.8)
                        }
                        .pressButtonStyle()

                        PlaybackPositionView()

                        HStack(spacing: 15) {
                            Button(action: playerManager.setShuffle){
                                Image(systemName: "shuffle")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                    .animation(.easeInOut(duration: 2.0), value: 1)
                                    .font(playerManager.shuffleIsOn ? Font.title.weight(.black) : Font.title.weight(.ultraLight))
                                    .opacity(playerManager.shuffleContextEnabled ? 1.0 : 0.45)
                            }
                            .pressButtonStyle()
                            .disabled(!playerManager.shuffleContextEnabled)

                            Button(action: playerManager.previousTrack){
                                Image(systemName: "backward.end.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .animation(.easeInOut(duration: 2.0), value: 1)
                            }
                            .pressButtonStyle()

                            PlayPauseButton(buttonSize: 40)

                            Button(action: playerManager.nextTrack) {
                                Image(systemName: "forward.end.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .animation(.easeInOut(duration: 2.0), value: 1)
                            }
                            .pressButtonStyle()

                            Button(action: playerManager.setRepeat){
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .font(playerManager.repeatIsOn ? Font.title.weight(.black) : Font.title.weight(.ultraLight))
                                    .opacity(playerManager.repeatContextEnabled ? 1.0 : 0.45)
                            }
                            .pressButtonStyle()
                            .disabled(!playerManager.repeatContextEnabled)
                        }
                        .opacity(0.8)
                        
                        HStack {
                            Menu {
                                ForEach(playerManager.audioDevices) { audioDevice in
                                    Button {
                                        playerManager.setOutputDevice(audioDevice: audioDevice)
                                    } label: {
                                        if audioDevice == playerManager.audioDevices.first(where: { $0.isDefault(for: .output) }) {
                                            Text("✓ \(audioDevice.name)")
                                        } else {
                                            Text(audioDevice.name)
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "hifispeaker.fill")
                            }
                            .frame(width: 20, height: 20)
                            .menuIndicator(.hidden)
                            .menuStyle(.borderlessButton)
                            
                            VolumeControlView()
                            
                            Button(action: openSettings){
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .pressButtonStyle()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 15)
                }
                .padding()
            }
        }
        .overlay(
            NotificationView()
                .padding(.top, 15)
        )
        .frame(
            width: AppDelegate.popoverWidth,
            height: 370
        )
    }
    
    func openSettings() {
        NSApplication.shared.sendAction(#selector(AppDelegate.openSettings), to: nil, from: nil)
    }
}

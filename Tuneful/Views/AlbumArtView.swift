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

struct AlbumArtView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @State private var isShowingPlaybackControls = false
    
    private var imageSize: CGFloat
    
    init(imageSize: CGFloat = 180) {
        self.imageSize = imageSize
    }
    
    var body: some View {
        ZStack {
            Image(nsImage: playerManager.track.albumArt)
                .resizable()
                .scaledToFill()
                .frame(width: self.imageSize, height: self.imageSize)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        
            if playerManager.isLikeAuthorized() {
                VStack {
                    // Like button
                    HStack(spacing: 6) {
                        Button {
                            playerManager.toggleLoveTrack()
                        } label: {
                            Image(systemName: playerManager.isLoved ? "star.fill" : "star")
                                .font(.system(size: 14))
                                .foregroundColor(.primary.opacity(0.8))
                        }
                        .pressButtonStyle()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(VisualEffectView(material: .popover, blendingMode: .withinWindow))
                    .cornerRadius(100)
                    .opacity(isShowingPlaybackControls ? 1 : 0)
                }
            }
        }
        .onHover { _ in
            withAnimation(.linear(duration: 0.1)) {
                self.isShowingPlaybackControls.toggle()
            }
        }
    }
}

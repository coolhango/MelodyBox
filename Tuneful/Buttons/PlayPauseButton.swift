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

struct PlayPauseButton: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @State private var transparency: Double = 0.0
    
    let buttonSize: CGFloat
    
    init(buttonSize: CGFloat = 30) {
        self.buttonSize = buttonSize
    }
    
    var body: some View {
        Button(action: {
            playerManager.togglePlayPause()
            transparency = 0.6
            withAnimation(.easeOut(duration: 0.2)) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    transparency = 0.0
                }
            }
        }) {
            ZStack {
                Image(systemName: "pause.circle.fill")
                    .resizable()
                    .frame(width: self.buttonSize, height: self.buttonSize)
                    .scaleEffect(playerManager.isPlaying ? 1.01 : 0.09)
                    .opacity(playerManager.isPlaying ? 1.01 : 0.09)
                    .animation(.interpolatingSpring(stiffness: 150, damping: 20), value: playerManager.isPlaying)
                
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: self.buttonSize, height: self.buttonSize)
                    .scaleEffect(playerManager.isPlaying ? 0.09 : 1.01)
                    .opacity(playerManager.isPlaying ? 0.09 : 1.01)
                    .animation(.interpolatingSpring(stiffness: 150, damping: 20), value: playerManager.isPlaying)
            }
        }
        .buttonStyle(MusicControlButtonStyle())
    }
}

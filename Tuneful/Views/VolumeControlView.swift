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

import Foundation
import Combine
import SwiftUI
import ISSoundAdditions

struct VolumeControlView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    @AppStorage("showPlayerWindow") var showPlayerWindow: Bool = true
    
    let volumeIconSize = CGFloat(12)
    
    var body: some View {
        HStack(spacing: 5) {
            Button(action: playerManager.decreaseVolume) {
                Image(systemName: "speaker.wave.1.fill")
                    .resizable()
                    .frame(width: volumeIconSize, height: volumeIconSize)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
            
            CustomSliderView(
                value: $playerManager.volume,
                isDragging: $playerManager.isDraggingSoundVolumeSlider,
                range: 0...100,
                knobDiameter: 5,
                knobColor: .white,
                knobScaleEffectMagnitude: 1.5,
                knobAnimation: .linear(duration: 0.15),
                leadingRectangleColor: .playbackPositionLeadingRectangle
            )
            
            Button(action: playerManager.increaseVolume) {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .frame(width: volumeIconSize, height: volumeIconSize)
                    .animation(.easeInOut(duration: 2.0), value: 1)
            }
            .pressButtonStyle()
        }
        .onChange(of: playerManager.volume, perform: { newVolume in
            playerManager.setVolume(newVolume: Int(newVolume))
        })
        .padding(.leading, 2)
        .padding(.trailing, 2)
    }
}

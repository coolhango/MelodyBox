// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code has been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓3

import Foundation
import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var playerManager: PlayerManager
    
    @State private var isPresented = false
    @State private var title = ""
    @State private var message = ""

    @State private var messageId = UUID()

    @State private var cancelButtonIsShowing = false

    let presentAnimation = Animation.spring(
        response: 0.5,
        dampingFraction: 0.9,
        blendDuration: 0
    )

    var body: some View {
        
        VStack {
            if isPresented {
                VStack {
                    Text(title)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 2)
                    if !message.isEmpty {
                        Text(message)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(7)
                .background(
                    VisualEffectView(
                        material: .popover,
                        blendingMode: .withinWindow
                    )
                )
                .cornerRadius(10)
                .padding(10)
                .shadow(radius: 5)
                .onHover { isHovering in
                    withAnimation(.easeOut(duration: 0.1)) {
                        self.cancelButtonIsShowing = isHovering
                    }
                }
                .transition(.move(edge: .top))
                
                Spacer()
            }
        }
        .onReceive(
            playerManager.notificationSubject,
            perform: recieveAlert(_:)
        )
        
    }
    
    func recieveAlert(_ alert: AlertItem) {
        let id = UUID()
        self.messageId = id

        self.title = alert.title
        self.message = alert.message

        withAnimation(self.presentAnimation) {
            self.isPresented = true
        }

        let delay: Double = message.isEmpty ? 2 : 3
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.messageId == id {
                withAnimation(self.presentAnimation) {
                    self.isPresented = false
                }
            }
        }
    }
}

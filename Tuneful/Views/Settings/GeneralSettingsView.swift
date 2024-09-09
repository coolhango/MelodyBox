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
import LaunchAtLogin

struct GeneralSettingsView: View {
    
    @AppStorage("connectedApp") private var connectedAppAppStorage = ConnectedApps.spotify
    
    @State private var alertTitle = Text("Title")
    @State private var alertMessage = Text("Message")
    @State private var showingAlert = false
    @State private var connectedApp: ConnectedApps
    
    init() {
        @AppStorage("connectedApp") var connectedAppAppStorage = ConnectedApps.spotify
        self.connectedApp = connectedAppAppStorage
    }
    
    var body: some View {
        Settings.Container(contentWidth: 400) {
            Settings.Section(title: "") {
                
                LaunchAtLogin
                    .Toggle()
                    .toggleStyle(.switch)
                
                HStack {
                    Picker("Connect MelodyBox to", selection: $connectedApp) {
                        ForEach(ConnectedApps.allCases, id: \.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                    .onChange(of: connectedApp) { _ in
                        self.connectedAppAppStorage = connectedApp
                    }
                    .pickerStyle(.segmented)
                    
                    Button {
                        let consent = Helper.promptUserForConsent(for: connectedApp == .spotify ? Constants.Spotify.bundleID : Constants.AppleMusic.bundleID)
                        switch consent {
                        case .closed:
                            alertTitle = Text("\(Text(connectedApp.localizedName)) is not open")
                            alertMessage = Text("Please open \(Text(connectedApp.localizedName)) to enable permissions")
                        case .granted:
                            alertTitle = Text("Permission granted for \(Text(connectedApp.localizedName))")
                            alertMessage = Text("Start playing a song!")
                        case .notPrompted:
                            return
                        case .denied:
                            alertTitle = Text("Permission denied")
                            alertMessage = Text("Please go to System Settings > Privacy & Security > Automation, and check \(Text(connectedApp.localizedName)) under MelodyBox")
                        }
                        showingAlert = true
                    } label: {
                        Image(systemName: "person.fill.questionmark")
                    }
                    .buttonStyle(.borderless)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: alertTitle, message: alertMessage, dismissButton: .default(Text("Got it!")))
                    }
                }
            }
        }
    }
}

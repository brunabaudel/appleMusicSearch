//
//  SongButton.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 19/10/23.
//

import SwiftUI

struct SongButton: View {
    @StateObject var playerManager: PlayerManager
    @State private var isPlaying: Bool = false
    let previewAsset: PreviewAsset
    
    var body: some View {
        ZStack {
            CircularProgressView(progress: !isPlaying || previewAsset != playerManager.previewAsset || playerManager.progress == 1.0 ? 0.0 : playerManager.progress, color: .blue)
                .frame(width: 30, height: 30)

            Button {
                action()
            } label: {
                Image(systemName: !isPlaying || previewAsset != playerManager.previewAsset || playerManager.progress == 1.0 ? "play.fill" : "pause.fill")
            }
        }
    }
    
    private func action() {
        if playerManager.audioPlayer?.timeControlStatus == .playing &&
            previewAsset == playerManager.previewAsset {
            playerManager.pauseAudio()
            isPlaying = false
        } else if playerManager.audioPlayer?.timeControlStatus == .paused ||
            previewAsset != playerManager.previewAsset {
            playerManager.previewAsset = previewAsset
            playerManager.setupAudio()
            playerManager.playAudio()
            isPlaying = true
        }
    }
}

struct SongButton_Previews: PreviewProvider {
    static var previews: some View {
        SongButton(playerManager: PlayerManager(), previewAsset: PreviewAsset(name: "", artist: "", imageURL: nil, previewSongURL: nil))
    }
}


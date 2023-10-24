//
//  PlayerManager.swift
//  MusicBeats
//
//  Created by Bruna Baudel on 18/10/23.
//

import AVKit

final class PlayerManager: NSObject, ObservableObject {
    @Published var audioPlayer: AVPlayer?
    @Published var previewAsset: PreviewAsset?
    @Published var progress: Double = 0.0
    private var observer: Any? = nil
    
    func setupAudio() {
        if let audioURL = self.previewAsset?.previewSongURL {
            self.progress = 0.0
            let item = AVPlayerItem(url: audioURL)
            
            if audioPlayer == nil {
                audioPlayer = AVPlayer(playerItem: item)
                observer = audioPlayer?.addProgressObserver { prog in
                    self.progress = prog
                }
                return
            }
            
            audioPlayer?.replaceCurrentItem(with: item)
            if observer != nil { audioPlayer?.removeTimeObserver(observer as Any) }
            observer = audioPlayer?.addProgressObserver { prog in
                self.progress = prog
            }
        }
    }
    
    func playAudio() {
        audioPlayer?.play()
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}

extension AVPlayer {
    func addProgressObserver(action: @escaping ((Double) -> Void)) -> Any {
        return self.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if let duration = self.currentItem?.duration {
                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                let progress = (time/duration)
                action(progress)
            }
        })
    }
    
    func removeProgressObserver1(observer: Any) {
        self.removeTimeObserver(observer)
    }
}

//
//  AudioPlayerService.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 18.10.2021.
//

import Foundation
import AVFoundation
import RxSwift

protocol AudioPlayerServiceProtocol {
  func play()
  func pause()
  func setItem(_ item: PlayerItem)
  var playbackProgress: Observable<Double> { get }
  var isPlaying: Observable<Bool> { get }
  func setPlaybackProgress(_ value: Double)
  func seekForward(offset: Double)
  func seekBackward(offset: Double)
  var seeking: Bool { get }
}

class AudioPlayerService: AudioPlayerServiceProtocol {
  
  static let shared = AudioPlayerService()
    
  let playbackProgressSubject = PublishSubject<Double>()
  var playbackProgress: Observable<Double> {
    return playbackProgressSubject.asObservable()
  }
  
  var isPlaying: Observable<Bool> {
    return player.rx.observe(Float.self, #keyPath(AVPlayer.rate)).filterNil().map { $0 > 0 }
  }
  
  let player = AVPlayer()
  
  private(set) var seeking = false
  
  private init() {
    player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: nil) { [unowned self] currentTime in
      if let duration = player.currentItem?.duration.seconds {
        let progress = currentTime.seconds / duration
        playbackProgressSubject.onNext(progress)
      }
    }
  }
  
  func seekForward(offset: Double) {
    let duration = player.currentItem?.duration.seconds ?? 0.0
    let currentTime = player.currentTime().seconds
    let targetTime = (currentTime + offset).clamped(min: 0, max: duration)
    let targetCMTime = CMTimeMakeWithSeconds(targetTime, preferredTimescale: player.currentTime().timescale)
    player.seek(to: targetCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
  }
  
  func seekBackward(offset: Double) {
    let duration = player.currentItem?.duration.seconds ?? 0.0
    let currentTime = player.currentTime().seconds
    let targetTime = (currentTime - offset).clamped(min: 0, max: duration)
    let targetCMTime = CMTimeMakeWithSeconds(targetTime, preferredTimescale: player.currentTime().timescale)
    player.seek(to: targetCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
  }
  
  func play() {
    player.play()
  }
  
  func pause() {
    player.pause()
  }
  
  func setItem(_ item: PlayerItem) {
    let plItem = AVPlayerItem(url: item.contentURL)
		NotificationCenter.default.addObserver(
			forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
			object: plItem,
			queue: nil) { _ in
				self.setPlaybackProgress(0)
			}
    player.replaceCurrentItem(with: plItem)
  }
  
  func setPlaybackProgress(_ value: Double) {
    guard !seeking else { return }
    seeking = true
    if let duration = player.currentItem?.duration {
      let result = CMTimeMultiplyByFloat64(duration, multiplier: value)
      player.seek(to: result, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
        self.seeking = false
      }
    }
  }
}

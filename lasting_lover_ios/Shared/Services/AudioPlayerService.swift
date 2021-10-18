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
  func setItem(_ item: _PlayerItem)
  var playbackProgress: Observable<Double> { get }
  var isPlaying: Observable<Bool> { get }
  func setPlaybackProgress(_ value: Double)
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
  
  private var seeking = false
  
  private init() {
    player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: nil) { [unowned self] currentTime in
      if let duration = player.currentItem?.duration.seconds {
        let progress = currentTime.seconds / duration
        playbackProgressSubject.onNext(progress)
      }
    }
  }
  
  func play() {
    player.play()
  }
  
  func pause() {
    player.pause()
  }
  
  func setItem(_ item: _PlayerItem) {
    let plItem = AVPlayerItem(url: item.contentURL)
    player.replaceCurrentItem(with: plItem)
  }
  
  func setPlaybackProgress(_ value: Double) {
    guard !seeking else { return }
    seeking = true
    if let duration = player.currentItem?.duration {
      let result = CMTimeMultiplyByFloat64(duration, multiplier: value)
      player.seek(to: result, toleranceBefore: .zero, toleranceAfter: .zero) { finished in
        self.seeking = finished
      }
    }
  }
}

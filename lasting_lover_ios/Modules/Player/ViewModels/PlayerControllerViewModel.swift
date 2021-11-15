//
//  PlayerControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import Foundation
import RxSwift
import RxUNILib
import UIKit

class PlayerControllerViewModel {
  struct Input {  
    let playTap: AnyObserver<Void>
    let favoriteTap: AnyObserver<Void>
    let seekToProgress: AnyObserver<Double>
    let fwdTap: AnyObserver<Void>
    let bcwdTap: AnyObserver<Void>
    let backTap: AnyObserver<Void>
  }
  
  private let backTapSubject = PublishSubject<Void>()
  private let fwdTapSubject = PublishSubject<Void>()
  private let bcwdTapSubject = PublishSubject<Void>()
  private let playTapSubject = PublishSubject<Void>()
  private let favoriteTapSubject = PublishSubject<Void>()
  private let seekToProgressSubject = PublishSubject<Double>()
  
  struct Output {
    let title: Observable<String>
    let author: Observable<String>
    let isFavorite: Observable<Bool>
    let isPlaying: Observable<Bool>
    let image: Observable<UIImage>
    let playbackProgress: Observable<Double>
		let currentTime: Observable<String>
		let totalDuration: Observable<String>
  }
  
  let input: Input
  let output: Output
  
  private let disposeBag = DisposeBag()
  
  init(
    state: Observable<Player.State>,
    dispatch: @escaping DispatchFunction<Player.Action>
  ) {
    self.input = Input(
      playTap: playTapSubject.asObserver(),
      favoriteTap: favoriteTapSubject.asObserver(),
      seekToProgress: seekToProgressSubject.asObserver(),
      fwdTap: fwdTapSubject.asObserver(),
      bcwdTap: bcwdTapSubject.asObserver(),
      backTap: backTapSubject.asObserver()
    )
    self.output = Output(
      title: state.map { $0.item.title }.distinctUntilChanged(),
      author: state.map { $0.item.authorName }.distinctUntilChanged(),
      isFavorite: state.map { $0.isFavourite }.distinctUntilChanged(),
      isPlaying: state.map { $0.isPlaying }.distinctUntilChanged(),
      image: state.map { $0.item.artworkURL }.distinctUntilChanged().flatMap { url in Current.imageLoadingService().image(url) },
			playbackProgress: state.map { $0.playbackProgress }.distinctUntilChanged(),
			currentTime: state.map { Int(Double($0.item.duration) * $0.playbackProgress).secondsToTime() },
			totalDuration: state.map { $0.item.duration.secondsToTime() }
    )
    
    dispatch(.initializePlayerWithItem)
    
    disposeBag.insert(
      fwdTapSubject.bind {
        dispatch(.fwdSeek)
      },
      bcwdTapSubject.bind {
        dispatch(.bcwdSeek)
      },
      playTapSubject.bind {
        dispatch(.playTap)
      },
      favoriteTapSubject.bind {
        dispatch(.favoriteTap)
      },
      seekToProgressSubject.bind { value in
        dispatch(.seekToProgress(value: value))
      }
    )
  }
}

//
//  FlagFeature.swift
//  ViewFeatures/FlagFeature
//
//  Created by Douglas Adams on 1/31/23.
//

import AppKit
import Foundation
import ComposableArchitecture

import FlexApi

public struct FlagFeature: ReducerProtocol {
  
  public init() {}
  
  public struct State: Equatable {
    public var isOnSide: Bool

    public init(isOnSide: Bool = false) {
      self.isOnSide = isOnSide
    }
  }
  
  public enum Action: Equatable {
    case closeButton
    case filter(Int)
    case letterClick
    case qskButton
    case quickMode(Int)
    case sliceProperty(Slice, Slice.Property, String)
    case splitClick
  }
  
  public func reduce(into state: inout State, action: Action) ->  EffectTask<Action> {
    switch action {
    case .closeButton:
      // FIXME:
      print("closeButton")
      return .none

    case .filter(let number):
      // FIXME:
      print("filter: \(number)")
      return .none
      
    case .letterClick:
      // FIXME:
      print("letterClick")
      return .none

    case .qskButton:
      // FIXME:
      print("qskButton")
      return .none

    case .quickMode(let number):
      // FIXME:
      print("quickMode: \(number)")
      return .none

    case .sliceProperty(let slice, let property, let stringValue):
      return .run { _ in await slice.setAndSend(property, stringValue) }

    case .splitClick:
      // FIXME:
      print("splitClick")
      return .none
    }
  }
}

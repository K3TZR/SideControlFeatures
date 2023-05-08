//
//  ControlView.swift
//  ControlFeatures/ControlFeature
//
//  Created by Douglas Adams on 11/13/22.
//

import SwiftUI
import ComposableArchitecture

import FlexApi
import SideCwFeature
import SideEqFeature
import FlagFeature
import SidePh1Feature
import SidePh2Feature
import SideTxFeature

// ----------------------------------------------------------------------------
// MARK: - View

public struct SideControlView: View {
  let store: StoreOf<SideControlFeature>
  @ObservedObject var apiModel: ApiModel
  @ObservedObject var objectModel: ObjectModel
  
  public init(store: StoreOf<SideControlFeature>, apiModel: ApiModel, objectModel: ObjectModel) {
    self.store = store
    self.apiModel = apiModel
    self.objectModel = objectModel
  }
  
  public var body: some View {
    
    WithViewStore(self.store) { viewStore in
      
      VStack(alignment: .center) {
        HStack {
          ControlGroup {
            Toggle("Rx", isOn: viewStore.binding(get: { $0.rxState != nil }, send: .rxButton ))
            Toggle("Tx", isOn: viewStore.binding(get: { $0.txState != nil }, send: .txButton ))
            Toggle("Ph1", isOn: viewStore.binding(get: { $0.ph1State != nil }, send: .ph1Button ))
            Toggle("Ph2", isOn: viewStore.binding(get: { $0.ph2State != nil }, send: .ph2Button ))
            Toggle("Cw", isOn: viewStore.binding(get: { $0.cwState != nil }, send: .cwButton ))
            Toggle("Eq", isOn: viewStore.binding(get: { $0.eqState != nil }, send: .eqButton ))
          }
          .frame(width: 280)
          .disabled(apiModel.clientInitialized == false)
        }
        Spacer()
        
        ScrollView {
          if apiModel.clientInitialized {
            VStack {
              IfLetStore( self.store.scope(state: \.rxState, action: SideControlFeature.Action.rx),
                          then: { store in FlagView(store: store) })
              
              IfLetStore( self.store.scope(state: \.txState, action: SideControlFeature.Action.tx),
                          then: { store in TxView(store: store) })
              
              IfLetStore( self.store.scope(state: \.ph1State, action: SideControlFeature.Action.ph1),
                          then: { store in Ph1View(store: store, objectModel: objectModel) })
              
              IfLetStore( self.store.scope(state: \.ph2State, action: SideControlFeature.Action.ph2),
                          then: { store in Ph2View(store: store) })
              
              IfLetStore( self.store.scope(state: \.cwState, action: SideControlFeature.Action.cw),
                          then: { store in CwView(store: store) })
              
              IfLetStore( self.store.scope(state: \.eqState, action: SideControlFeature.Action.eq),
                          then: { store in EqView(store: store) })
            }
            .padding(.horizontal, 10)
            
          } else {
            EmptyView()
          }
        }
      }
      .onChange(of: apiModel.clientInitialized) {
        viewStore.send(.openClose($0))
      }
    }
    .frame(width: 275)
  }
}

// ----------------------------------------------------------------------------
// MARK: - Preview

struct RightSideView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      FlagView(
        store: Store(
          initialState: FlagFeature.State(),
          reducer: FlagFeature()
        )
      )
      .previewDisplayName("Rx")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(txButton: true),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .previewDisplayName("Tx")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(eqButton: true, txEqSelected: false),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .previewDisplayName("Eq")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(ph1Button: true),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .previewDisplayName("Ph1")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(ph2Button: true),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .previewDisplayName("Ph2")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(cwButton: true),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .previewDisplayName("CW")
      
      SideControlView(
        store: Store(
          initialState: SideControlFeature.State(cwButton: true, eqButton: true, ph1Button: true, ph2Button: true, rxButton: true, txButton: true, txEqSelected: false),
          reducer: SideControlFeature()
        ), apiModel: ApiModel(), objectModel: ObjectModel()
      )
      .frame(height: 1200)
      .previewDisplayName("ALL")
      
    }
    .frame(width: 275)
  }
}

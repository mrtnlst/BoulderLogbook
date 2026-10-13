//
//  HorizontalSelectionFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 10.10.26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct HorizontalSelectionFeature<Element: HorizontalSelectionElement> {
    @ObservableState
    struct State {
        var scrollPosition = ScrollPosition(idType: Element.ID.self)
        var selectedElement: Element?

        let elements: [Element]
        
        init(elements: [Element]) {
            self.elements = elements
        }
    }
    
    enum Action: ViewAction {
        enum Delegate {
            case didSelectElement(Element)
        }
        enum View {
            case task
            case didSelectElement(Element)
        }
        case setScrollPosition(ScrollPosition)
        case delegate(Delegate)
        case view(View)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.task):
                state.selectedElement = state.elements.first
                
            case let .view(.didSelectElement(element)):
                state.scrollPosition.scrollTo(id: element.id, anchor: .leading)

            case let .setScrollPosition(position):
                state.scrollPosition = position
                let selectedElement = state.elements.first {
                    $0.id == position.viewID(
                        type: Element.ID.self
                    )
                }
                if let selectedElement, selectedElement != state.selectedElement {
                    state.selectedElement = selectedElement
                    return .send(.delegate(.didSelectElement(selectedElement)))
                }
            default: ()
            }
            return .none
        }
    }
}

//
//  HorizontalSelectionView.swift
//  BoulderLogbook
//
//  Created by Martin List on 10.10.26.
//

import SwiftUI
import ComposableArchitecture

fileprivate extension CGFloat {
    static let leadingMargin: CGFloat = 8
    static let horizontalSpacing: CGFloat = 16
}

struct HorizontalSelectionView<Element: HorizontalSelectionElement>: View {
    @Environment(\.isEnabled) var isEnabled
    @State private var scrollViewWidth: CGFloat = 0
    @State private var lastElementWidth: CGFloat = 0
    @ScaledMetric private var scrollViewHeight: CGFloat = 50
    private let leadingMargin: CGFloat = 8

    @Bindable var store: StoreOf<HorizontalSelectionFeature<Element>>
    let prefix: String?
    let borderColor: Color
    
    private var trailingMargin: CGFloat {
        max(0, scrollViewWidth - .leadingMargin - lastElementWidth)
    }
    
    var body: some View {
        if store.elements.isEmpty {
            emptyView
        } else {
            scrollView
        }
    }
}

private extension HorizontalSelectionView {
    var emptyView: some View {
        Text("No elements available!")
            .foregroundStyle(.secondaryText)
            .frame(height: scrollViewHeight)
    }

    var scrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .horizontalSpacing) {
                ForEach(store.elements) { element in
                    Button {
                        store.send(.view(.didSelectElement(element)))
                    } label: {
                        Text((self.prefix ?? "") + element.name)
                            .id(element)
                            .foregroundStyle(Color.araTextPrimary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(borderColor, lineWidth: 3)
                            )
                            .opacity(store.selectedElement?.id == element.id ? 1.0 : 0.3)
                            .onGeometryChange(for: CGFloat.self) {
                                $0.size.width
                            } action: { width in
                                if element.id == store.elements.last?.id {
                                    lastElementWidth = width
                                }
                            }
                            .padding(.vertical, 2)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.leading, .leadingMargin, for: .scrollContent)
        .contentMargins(.trailing, trailingMargin, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition($store.scrollPosition.sending(\.setScrollPosition))
        .animation(.easeInOut, value: store.scrollPosition)
        .frame(height: scrollViewHeight)
        .onGeometryChange(for: CGFloat.self) {
            $0.size.width
        } action: {
            scrollViewWidth = $0
        }
        .sensoryFeedback(.selection, trigger: store.selectedElement) { oldValue, _ in
          oldValue != nil
        }
        .task { store.send(.view(.task)) }
        .opacity(isEnabled ? 1.0 : 0.4)
    }
}

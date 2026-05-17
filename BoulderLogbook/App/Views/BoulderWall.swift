//
//  BoulderWall.swift
//  BoulderLogbook
//
//  Created by Martin List on 17.05.26.
//

import SwiftUI

struct BoulderWall: View {
    var body: some View {
        GeometryReader { proxy in
            let squareLength = proxy.size.width / 3
            let numberOfRows = Int(ceil(proxy.size.height / max(1, squareLength))) * 3
            let range = -(squareLength / 2)...(squareLength / 2)
            AnyLayout(FlowLayout()) {
                ForEach(0..<numberOfRows, id: \.self) { index in
                    Image(.boulderHold)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(
                            Color.araAll.randomElement()?.opacity(0.6) ?? .araRed.opacity(0.6)
                        )
                        .offset(
                            x: CGFloat.random(in: range),
                            y: CGFloat.random(in: range)
                        )
                        .rotationEffect(
                            .degrees(
                                .random(in: 0...360)
                            )
                        )
                        .frame(
                            width: squareLength,
                            height: squareLength
                        )
//                        .border(Color.gray)
                }
            }
        }
        .background(Color.background)
    }
}

struct FlowLayout: Layout {
     var spacing: CGFloat = 0
 
     func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
     ) -> CGSize {
         
         let containerWidth = proposal.width ?? .infinity
         let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
         return layout(
            sizes: sizes,
            spacing: spacing,
            containerWidth: containerWidth
         ).size
     }
    
     func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
     ) {
         let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
         let offsets =
         layout(
            sizes: sizes,
            spacing: spacing,
            containerWidth: bounds.width
         ).offsets
         for (offset, subview) in zip(offsets, subviews) {
             subview.place(
                at: .init(
                    x: offset.x + bounds.minX,
                    y: offset.y + bounds.minY
                ),
                proposal: .unspecified
             )
         }
     }
    
    func layout(
        sizes: [CGSize],
        spacing: CGFloat = 8,
        containerWidth: CGFloat
    ) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        
        var currentPosition: CGPoint = .zero
        
        var lineHeight: CGFloat = 0
        
        var maxX: CGFloat = 0
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            result.append(currentPosition)
            currentPosition.x += size.width
            
            maxX = max(maxX, currentPosition.x)
            currentPosition.x += spacing
            lineHeight = max(lineHeight, size.height)
        }
        return (result,
                .init(width: maxX, height: currentPosition.y + lineHeight))
    }
 }

#Preview {
    BoulderWall()
}

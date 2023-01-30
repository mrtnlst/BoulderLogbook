//
//  RectangularButton.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI

struct RectangularButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text("")
                    .hidden()
                Spacer()
                Text(title)
                Spacer()
            }
        }
    }
}

struct RectangularButton_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RectangularButton(title: "Save", action: {})
                .foregroundColor(.green)
            
            RectangularButton(title: "Cancel", action: {})
                .foregroundColor(.red)
        }
    }
}

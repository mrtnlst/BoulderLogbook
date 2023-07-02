//
//  AppIconView.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import UIKit
import SwiftUI

struct AppIconView: View {
    let iconName: String?
    
    var body: some View {
        if let iconName = iconName, let icon = UIImage(named: iconName) {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 4)
        } else {
            Image(systemName: "app.dashed")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView(iconName: nil)
    }
}

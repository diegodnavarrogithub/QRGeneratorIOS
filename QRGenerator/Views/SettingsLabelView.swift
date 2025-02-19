//
//  SettingsLabelView.swift
//  QRGenerator
//
//  Created by Diego Dominguez on 30/08/24.
//

import SwiftUI

struct SettingsLabelView: View {
    //MARK: - PROPERTIES
    var labelText: String
    var labelImage: String
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Text(labelText.uppercased()).fontWeight(.bold)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

struct SettingsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabelView(labelText: "QRGenerator", labelImage: "info.circle")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

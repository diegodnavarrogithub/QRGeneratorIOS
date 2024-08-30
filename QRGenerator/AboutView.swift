//
//  AboutView.swift
//  QRGenerator
//
//  Created by Diego Dominguez on 30/08/24.
//

import SwiftUI

struct AboutView: View {
    //    MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    //    MARK: - BODDY
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    
                    //MARK: - SECTION 1
                    GroupBox(
                        label:
                            SettingsLabelView(labelText: "QRGenerator", labelImage: "info.circle")
                    ){
                        Divider().padding(.vertical, 4)
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(9)
                            Text("A simple and easy-to-use QR code generator for iOS. Create your own QR codes with just a few taps, no login or account required.\nYour code will be removed if it hasn’t been scanned in 6 months. We do not collect any data; however, we use a redirect method to keep track of code usage. That is all we do.")
                                .font(.footnote)
                        }
                    }
                    
                    //MARK: - SECTION 2
                    GroupBox(
                        label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")
                    ){
                        SettingsRowView(name: "Developer", content: "Diego D. Navarro")
                        SettingsRowView(name: "Website", linklbl: "diegodnavarro.com", linkDestination: "https://www.diegodnavarro.com")
                        SettingsRowView(name: "Compatibility", content: "\(Bundle.main.infoDictionary?["MinimumOSVersion"] as? String ?? "18")+")
                        SettingsRowView(name: "Version", content: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
                        
                    }
                    
                    //MARK: - SECTION 3
                    
                }//: VSTACK
                .navigationBarTitle(Text("Settings"), displayMode: .large)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                        }
                )
                .padding()
            }//: SCROLL
        }//: NAVIGATION
    }
}

#Preview {
    AboutView()
}

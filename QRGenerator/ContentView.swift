//
//  ContentView.swift
//  QRGenerator
//
//  Created by Diego Dominguez on 30/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QRViewModel()
    @State private var inputUrl: String = ""
    @State private var showQRCodeView = false
    @State private var isLoading = false // State to track loading
    @State private var showAboutSheet = false // State to control the About sheet

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("https://")
                        .foregroundColor(.gray) // Optional: Style the prefix in gray
                    TextField("Enter URL", text: $inputUrl)
                        .padding(.vertical, 8)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal)

                Button(action: {
                    isLoading = true // Show loading spinner
                    let formatted = formatURL(inputUrl)
                    inputUrl = formatted.replacingOccurrences(of: "https://", with: "") // Update input with just the domain
                    viewModel.generateQRCode(from: formatted)
                }) {
                    Text("Generate QR Code")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.accentColor)  // Set the background color
                .cornerRadius(25)        // Make the button rounded
                .padding(.horizontal)
                .shadow(radius: 5)       // Optional: Add a shadow for better appearance

                if isLoading {
                    ProgressView() // Loading spinner
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("QR Code Generator")
            .navigationDestination(isPresented: $showQRCodeView) {
                qrCodeDestination
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAboutSheet = true // Show the About sheet
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showAboutSheet) {
                AboutView() // Present the About view as a sheet
            }
        }
        .onChange(of: viewModel.qrImage) { oldValue, newValue in
            isLoading = false // Hide spinner when loading is complete
            if newValue != nil {
                showQRCodeView = true
            }
        }
    }

    private var qrCodeDestination: some View {
        if let qrImage = viewModel.qrImage {
            return AnyView(QRCodeView(qrImage: qrImage, url: "https://" + inputUrl))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // Helper function to format the URL
    func formatURL(_ url: String) -> String {
        var formattedURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Ensure the URL starts with https://
        if !formattedURL.lowercased().hasPrefix("http://") && !formattedURL.lowercased().hasPrefix("https://") {
            formattedURL = "https://\(formattedURL)"
        }
        
        return formattedURL
    }
}

#Preview {
    ContentView()
}

//
//  RequestHandler.swift
//  QRGenerator
//
//  Created by Diego Dominguez on 30/08/24.
//

import SwiftUI
import Combine

class QRViewModel: ObservableObject {
    @Published var qrImage: Image? = nil
    @Published var errorMessage: String? = nil

    // Function to generate QR code by calling the API
    func generateQRCode(from url: String) {

        guard let apiUrl = URL(string: "https://\(Bundle.main.object(forInfoDictionaryKey: "API_URL")! as! String)/generate")else {
            self.errorMessage = "Invalid API URL"
            return
        }
        print(apiUrl)
        // Prepare the request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode the request payload
        let payload = QRRequest(destination_url: url)
        guard let httpBody = try? JSONEncoder().encode(payload) else {
            self.errorMessage = "Failed to encode request"
            return
        }
        request.httpBody = httpBody

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data, let qrResponse = try? JSONDecoder().decode(QRResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
                return
            }

            // Decode the base64 string into an image
            if let imageData = Data(base64Encoded: qrResponse.qr_image) {
                #if os(macOS)
                if let nsImage = NSImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.qrImage = Image(nsImage: nsImage)
                    }
                }
                #else
                if let uiImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.qrImage = Image(uiImage: uiImage)
                    }
                }
                #endif
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode image data"
                }
            }
        }.resume()
    }
}

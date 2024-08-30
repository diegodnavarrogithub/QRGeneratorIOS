import SwiftUI

struct QRCodeView: View {
    let qrImage: Image
    let url: String

    var body: some View {
        VStack {
            Text(url)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding()
            
            qrImage
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: shareQRCode) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func shareQRCode() {
        // iOS and iPadOS share logic using UIActivityViewController
        guard let qrUIImage = qrImage.asUIImage() else { return }
        let activityController = UIActivityViewController(activityItems: [qrUIImage], applicationActivities: nil)

        // Find the first active scene and present the activity controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

// Extension to convert SwiftUI Image to UIImage
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let size = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

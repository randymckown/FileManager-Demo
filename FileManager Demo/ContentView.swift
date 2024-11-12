//
//  ContentView.swift
//  FileManager Demo
//
//  Created by Randy McKown on 11/12/24.
//

import SwiftUI
import UIKit
import PDFKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Create and Share a PDF")
                .font(.title)
                .padding()

            Button(action: {
                createPDFFile()
            }) {
                Text("Save and Share PDF")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    func createPDFFile() {
        // Define the content to be added to the PDF
        let content = "Hello FileManager"

        // Create a PDF context with the file URL
        let fileName = "helloFileManager.pdf"
        let fileManager = FileManager.default
        
        do {
            // Get the URL for the app's document directory
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL.appendingPathComponent(fileName)

            // Create a PDF context with a page size
            let pdfContext = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 400, height: 600))
            let data = pdfContext.pdfData { (context) in
                context.beginPage()
                
                // Draw the content in the PDF
                let textRect = CGRect(x: 20, y: 20, width: 360, height: 560)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 20),
                    .foregroundColor: UIColor.black
                ]
                content.draw(in: textRect, withAttributes: attributes)
            }

            // Write the generated PDF data to the file URL
            try data.write(to: fileURL)
            print("PDF saved at: \(fileURL.path)")
            
            // Share the file using UIActivityViewController
            shareFile(fileURL)
            
        } catch {
            print("Error creating or writing to PDF: \(error.localizedDescription)")
        }
    }

    // Share the file using UIActivityViewController
    func shareFile(_ fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // Present the UIActivityViewController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}

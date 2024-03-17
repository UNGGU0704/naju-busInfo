
//  File.swift
//  app
//
//  Created by 김규형 on 3/16/24.
//

import Foundation
import SwiftUI
import PDFKit



// PDF 번호와 파일명을 매칭하는 Dictionary
let pdfMapping: [Int: Int] = [
    1: 1,
    997: 40
]

struct PDFViewer: View {
    let selectedPDFNumber: Int
    
    var body: some View {
        VStack {
            // 선택된 PDF 번호에 따라 해당하는 PDF를 표시
            if let pdfFileName = pdfMapping[selectedPDFNumber],
               let pdfURL = Bundle.main.url(forResource: "resources/timetablePDF/citybus_+\(pdfFileName)", withExtension: "pdf") {
                PDFKitRepresentedView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text(String(selectedPDFNumber) + "PDF 파일을 찾을 수 없습니다.")
            }
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

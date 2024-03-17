import SwiftUI
import PDFKit

// PDF 번호와 파일 URL을 매칭하는 Dictionary
let pdfMapping: [Int: URL] = [
    1: URL(string: "https://www.example.com/example1.pdf")!,
    997: URL(string: "https://www.naju.go.kr/contents/9353/231030/citybus_100.pdf")!
]

struct PDFViewer: View {
    let selectedPDFNumber: Int
    
    @State private var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            // PDF를 로드하는데 실패했을 때 에러 메시지를 표시합니다.
            if pdfDocument == nil {
                Text("PDF 파일을 로드하는 중입니다...")
            } else {
                PDFKitRepresentedView(document: pdfDocument!)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            // PDF 매핑에서 해당 PDF의 URL을 가져옵니다.
            if let pdfURL = pdfMapping[selectedPDFNumber] {
                // 외부 URL에서 직접 PDF를 로드합니다.
                URLSession.shared.dataTask(with: pdfURL) { data, response, error in
                    if let data = data, let document = PDFDocument(data: data) {
                        DispatchQueue.main.async {
                            self.pdfDocument = document
                        }
                    } else {
                        print("Error: PDF 파일을 로드할 수 없습니다.")
                    }
                }.resume()
            } else {
                print("Error: PDF 매핑을 찾을 수 없습니다.")
            }
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}

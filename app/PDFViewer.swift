import SwiftUI
import PDFKit

// PDF 번호와 파일 URL을 매칭하는 Dictionary
let pdfMapping: [String: URL] = [
    "997": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_40.pdf")!,
    "998": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_41.pdf")!,
    "999": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_42.pdf")!,
    "160": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_160.pdf")!,
    "161": URL(string: "https://www.naju.go.kr/contents/9353/230916/161_01.pdf")!,
    "급행01": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_fast01_231227.pdf")!,
    "급행03": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_fast03.pdf")!,
    "11": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_11.pdf")!,
    "12": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_12.pdf")!,
    "13": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_13.pdf")!,
    "14": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_14.pdf")!,
    "15": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_15.pdf")!,
    "21": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_21_new.pdf")!,
    "22": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_28.pdf")!,
    "23": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_29.pdf")!,
    "31": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_31.pdf")!,
    "32": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_32.pdf")!,
    "100": URL(string: "https://www.naju.go.kr/contents/9353/231030/citybus_100.pdf")!,
    "101": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_101.pdf")!,
    "200": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_200.pdf")!,
    "201": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_201.pdf")!,
    "300": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_300.pdf")!,
    "5": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_5.pdf")!,
    "6": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_6.pdf")!,
    "400": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_400.pdf")!,
    "401": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_401.pdf")!,
    "402": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_402.pdf")!,
    "403": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_403.pdf")!,
    "500": URL(string: "https://www.naju.go.kr/contents/9353/231220/citybus_500.pdf")!,
    "600": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_600.pdf")!,
    "601": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_601.pdf")!,
    "602": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_602.pdf")!,
    "700": URL(string: "https://www.naju.go.kr/contents/9353/231026/citybus_700.pdf")!,
    "701": URL(string: "https://www.naju.go.kr/contents/9353/231220/citybus_701.pdf")!,
    "702": URL(string: "https://www.naju.go.kr/contents/9353/231220/citybus_702.pdf")!,
    "7000": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_16.pdf")!,
    "7001": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_17.pdf")!,
    "7002": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_18.pdf")!,
    "셔틀1": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_19.pdf")!,
    "셔틀2": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_20.pdf")!,
    "순환1": URL(string: "https://www.naju.go.kr/contents/9353/240126/citybus_21.pdf")!,
    "순환2": URL(string: "https://www.naju.go.kr/contents/9353/240126/citybus_22.pdf")!,
    "순환3": URL(string: "https://www.naju.go.kr/contents/9353/240126/citybus_23.pdf")!
]


struct PDFViewer: View {
    let selectedPDFNumber: String
    
    @State private var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            // PDF를 로드하는데 실패
            if pdfDocument == nil {
                Text("죄송합니다 현재 시간표가 제공되지 않는 노선입니다.")
            } else {
                PDFKitRepresentedView(document: pdfDocument!)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            if let pdfURL = pdfMapping[selectedPDFNumber] {
                // 외부 URL에서 직접 PDF를 로드]
                URLSession.shared.dataTask(with: pdfURL) { data, response, error in
                    if let data = data, let document = PDFDocument(data: data) {
                        DispatchQueue.main.async {
                            self.pdfDocument = document
                        }
                    } else {
                        print(selectedPDFNumber + "Error: PDF 파일을 로드할 수 없습니다.")
                    }
                }.resume()
            } else {
                print(selectedPDFNumber + "Error: PDF 매핑을 찾을 수 없습니다.")
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

import SwiftUI
import PDFKit

// PDF 번호와 파일 URL을 매칭하는 Dictionary
let pdfMapping: [String: URL] = [
    "997": URL(string: "https://www.naju.go.kr/contents/10256/0320/areabus_997_0320.pdf")!,
    "998": URL(string: "https://www.naju.go.kr/contents/10256/0320/areabus_998_0320.pdf")!,
    "999": URL(string: "https://www.naju.go.kr/contents/10256/240329/citybus_999.pdf")!,
    "160": URL(string: "https://www.naju.go.kr/contents/10256/240329/citybus_160.pdf")!,
    "161": URL(string: "https://www.naju.go.kr/contents/10256/240329/citybus_161.pdf")!,
    "급행01": URL(string: "https://www.naju.go.kr/contents/9353/231222/citybus_fast01_231227.pdf")!,
    "급행03": URL(string: "https://www.naju.go.kr/contents/10041/bus_3_240610.pdf")!,
    "21": URL(string: "https://www.naju.go.kr/contents/10256/0320/bus_21_0320.pdf")!,
    "22": URL(string: "https://www.naju.go.kr/contents/10256/0320/bus_22_0320.pdf")!,
    "23": URL(string: "https://www.naju.go.kr/contents/10256/0320/bus_23_0320.pdf")!,
    "31": URL(string: "https://www.naju.go.kr/contents/10256/0320/bus_31_0320.pdf")!,
    "32": URL(string: "https://www.naju.go.kr/contents/10256/0320/bus_32_0320.pdf")!,
    "100": URL(string: "https://www.naju.go.kr/contents/10256/0315/citybus_100_0315.pdf")!,
    "101": URL(string: "https://www.naju.go.kr/images/www/citybus/240412/citybus_101_3.pdf")!,
    "200": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_200_0320.pdf")!,
    "201": URL(string: "https://www.naju.go.kr/images/www/citybus/240412/citybus_201_2.pdf")!,
    "300": URL(string: "https://www.naju.go.kr/contents/10256/0315/citybus_300_0315.pdf")!,
    "5": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_5.pdf")!,
    "6": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_6.pdf")!,
    "410": URL(string: "https://www.naju.go.kr/images/www/citybus/240412/citybus_410.pdf")!,
    "411": URL(string: "https://www.naju.go.kr/images/www/citybus/240412/citybus_411.pdf")!,
    "412": URL(string: "https://www.naju.go.kr/images/www/citybus/240412/citybus_412.pdf")!,
    "413": URL(string: "https://www.naju.go.kr/contents/10041/bus_413_240610.pdf")!,
    "500": URL(string: "https://www.naju.go.kr/contents/10041/bus_500_240610.pdf")!,
    "600": URL(string: "https://www.naju.go.kr/contents/10256/0315/citybus_600_0315.pdf")!,
    "601": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_601_0320.pdf")!,
    "602": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_602_0320.pdf")!,
    "700": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_700_0320.pdf")!,
    "701": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_701_0320.pdf")!,
    "702": URL(string: "https://www.naju.go.kr/contents/10041/bus_702_240610.pdf")!,
    "7000": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_7000_0320.pdf")!,
    "7001": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_7001_0320.pdf")!,
    "7002": URL(string: "https://www.naju.go.kr/contents/10256/0320/citybus_7002_0320.pdf")!,
    "셔틀1": URL(string: "https://www.naju.go.kr/contents/10256/240329/citybus_19_2.pdf")!,
    "셔틀2": URL(string: "https://www.naju.go.kr/contents/9353/230916/citybus_20.pdf")!,
    "순환1": URL(string: "https://www.naju.go.kr/contents/10256/0320/circular_1_0320.pdf")!,
    "순환2": URL(string: "https://www.naju.go.kr/contents/10256/0320/circular_2_0320.pdf")!,
    "순환3": URL(string: "https://www.naju.go.kr/contents/10256/0320/circular_3_0320.pdf")!
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

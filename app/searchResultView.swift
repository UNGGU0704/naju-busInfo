
import SwiftUI

struct busInfoResult: View {
    @Binding var infoList: [Arrival]
    @Binding var busStopName: String
    var body: some View {
        VStack(alignment: .leading) {
            if infoList.isEmpty {
                Text("정보가 없습니다.")
            } else {
                List(infoList.indices, id: \.self) { index in
                    let lineInfo = infoList[index]
                    VStack(alignment: .leading) {
                        Text("버스 번호: \(lineInfo.lineName)")
                        Text("도착까지 남은 정류장 갯수: \(lineInfo.remainStop)")
                        Text("남은 시간: \(lineInfo.remainMin) 분")
                    }
                }
            }
        }
    }
}




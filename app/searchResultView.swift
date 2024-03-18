
import SwiftUI
import CoreData

struct busInfoResult: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WishList.entity(), sortDescriptors: []) var wishList: FetchedResults<WishList>
    @State private var selectedArrival: [Arrival] = []
    var busStopName: String
    var busStopID:Int
    var nextBusStop: String
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isRotating = false
    
    var body: some View {
        VStack(alignment: .leading) {
                Section(header: HStack {
                    Text(busStopName)
                        .font(.custom("NotoSans-Bold", size: 24))
                        .lineLimit(1) // 한 줄로 제한
                        .minimumScaleFactor(0.5) // 최소 축소 비율 설정
                        .padding(.leading, 20) // 왼쪽 여백 추가
                    Spacer()
                    Text(nextBusStop)
                        .font(.subheadline)
                        .lineLimit(1) // 한 줄로 제한
                        .minimumScaleFactor(0.5) // 최소 축소 비율 설정
                        .padding(.trailing, 38) // 오른쪽 여백 추가
                        .padding(.bottom, -10)
                }.padding(.bottom, -5)
                    .padding(.top, -25)
                ) {
                
                    //정류장 정보가 아무것도 없을때 표시
                    if selectedArrival.isEmpty {
                        ZStack {
                            VStack {
                                Spacer()
                                Text("현재 정류장 버스 정보가 없습니다.")
                                    .multilineTextAlignment(.center)
                                    .padding() // 원하는 여백을 추가합니다.
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    List(selectedArrival.indices, id: \.self) { index in
                        let lineInfo = selectedArrival[index]
                
                        
                        HStack(spacing: 16) {
                            if lineInfo.lineName.contains("셔틀")||lineInfo.lineName.contains("우정") || lineInfo.lineName.contains("그린") {
                                Image(systemName: "bus")
                                    .font(.title)
                                    .foregroundColor(.green)
                            } else if lineInfo.lineName.contains("99") || lineInfo.lineName.contains("좌석") ||
                                        lineInfo.lineName.contains("160") || lineInfo.lineName.contains("161"){
                                Image(systemName: "bus")
                                    .font(.title)
                                    .foregroundColor(.purple)
                            } else {
                                Image(systemName: "bus")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                       
                               
                            NavigationLink(destination: LineinfoView(LineID: lineInfo.lineID, Linename: lineInfo.lineName, nowbusStopID: busStopID)){
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(lineInfo.lineName)번")
                                        .font(.headline)
                                    
                                    Text("남은 시간: \(lineInfo.remainMin) 분")
                                        .font(.subheadline)
                                    
                                    Text("도착까지 남은 정류장 갯수: \(lineInfo.remainStop)")
                                        .font(.subheadline)                    
                                }
                            }
                        
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        
                        .cornerRadius(10)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isRotating.toggle()
                                fetchData(for: busStopID)
                            }) {
                                Image(systemName: "arrow.clockwise.circle")
                                    .rotationEffect(.degrees(isRotating ? 360 : 0))
                                    .animation(.easeInOut(duration: 0.5), value: isRotating)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                saveToWishList()
                            }) {
                                Image(systemName: "heart.fill")
                            }.alert(isPresented: $showAlert) {
                                    Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                                }
                            
                        }
                    }
                }
            
            
        }
        .onAppear(){
            fetchData(for: busStopID)
        }
    }
    
    
    func saveToWishList() {
        withAnimation {
            let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "busStopID == %d", busStopID)
            
            do {
                let existingWishList = try viewContext.fetch(fetchRequest)
                
                if let wishItem = existingWishList.first {
                    // 이미 해당 ID를 가진 항목이 있으면 삭제
                    viewContext.delete(wishItem)
                    showAlert = true
                    alertMessage = "즐겨찾기에서 삭제되었습니다."
                } else {
                    // 해당 ID를 가진 항목이 없으면 추가
                    let newWishList = WishList(context: viewContext)
                    newWishList.busStopName = busStopName
                    newWishList.busStopID = Int32(busStopID)
                    newWishList.nextBusStop = nextBusStop
                    showAlert = true
                    alertMessage = "즐겨찾기에 추가되었습니다."
                }
                
                try viewContext.save() // 변경 내용을 저장합니다
            } catch {
                print("Failed to save wishlist item: \(error)")
            }
        }
    }
    
    
    public func fetchData(for busStopID: Int) {
        
        
        // Construct the URL for the API request
        guard var urlComponents = URLComponents(string: "http://121.147.206.212/json/arriveApi") else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "BUSSTOP_ID", value: "\(busStopID)")
        ]
        print("API 요청 사이트: " + "\(urlComponents)")
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                let decodedArrivals = apiResponse.arriveList
                
                DispatchQueue.main.async {
                    if decodedArrivals.isEmpty {
                        print("No bus arrivals found for bus stop ID: \(busStopID)")
                    } else {
                        self.selectedArrival = decodedArrivals  // 첫 번째 도착 정보를 선택
                    }
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
        
    }
}

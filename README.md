<p align="center">
   <img width="200" src="app/Assets.xcassets/AppIcon.appiconset/1024.png" alt="APP Logo"></p>
   
# <p align="center"  style="margin-top: -90px;"><b><span style="font-size: 24px;">나주버스</span></b></p>
<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.8-orange.svg?style=flat" alt="Swift 5.8">
   </a>
   </a>
   <img src="https://img.shields.io/badge/iOS-16%2B-brightgreen.svg?style=flat" alt="iOS 16+ Compatible">
   <a href="https://www.apple.com/kr/app-store/">
      <img src="https://img.shields.io/badge/Available%20on%20App%20Store-9b59b6.svg?style=flat" alt="Available on App Store">
</p>





# 나주 버스(Naju Bus)

나주시 시민들을 위한 버스 도착 정보를 제공하는 어플로써 버스 정류장을 검색하고 버스 도착까지 남은 시간을 알려주는 기능을 제공합니다.

## 기능(Features)

- [x] ℹ️ 정류장 데이터 부착
- [x] ℹ️ 정류장 검색
- [x] ℹ️ 도착 시간 제공
- [x] ℹ️ 즐겨 찾기 기능
- [x] ℹ️ 디자인 개선
- [x] ℹ️ 노선 정보 제공
- [ ] ℹ️ 다른 언어 지원


## 파일(File)

#### Main View.swift
- 앱 실행시 보이는 메인 화면입니다. \n
  버스 정류장을 검색하는 기능을 가지고 있습니다.
#### searchBus.swift
- 정류장 정보를 검색하는 기능을 가지고 있습니다.
#### searchResultView.swift
- 버스 정류장 이름을 기반으로 CoreData에서 정류장 정보를 검색하고 \n
  해당 정류장의 도착 정보를 표시하는 기능을 가지고 있습니다.
#### LineinfoView.swift
- 해당 노선이 지나가는 모든 버스 정류장을 보여줍니다. \n
  추가적으로 해당 노선이 현재 어디 있는지 또한 보여줍니다.
#### DB.swift
- CoreData의 저장, 삭제 기능을 가지고 있습니다.
#### DB view.swift
- CoreData에서 가져온 정류소 정보를 표시합니다.
  DB.swift의 생성 삭제 기능을 제어합니다.
#### PersistenceController.swift
- CoreData를 설정하고 영구 저장소를 로드합니다.
#### app.xcdatamodeld
- CoreData의 저장소입니다.

## 설치(Installation)

앱스토어에 등록 예정입니다.
현재 iPhone12, iPhone8 환경에서 정상 테스트 완료했습니다.


## 사용(Usage)

| 메인화면 | 정류장 검색 표시 |
| :---: | :---: |
| <img src="appTests/IMG_5918.PNG" width="200" align="center"> | <img src="appTests/IMG_5923.PNG" width="200" align="center"> |
| **도착 정보 표시** | **노선 정보 표시** |
| <img src="appTests/IMG_5924.PNG" width="200" align="center"> | <img src="appTests/IMG_6934.PNG" width="200" align="center"> |

<img width="69" alt="스크린샷 2023-06-20 오후 11 36 52" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/16bc9a8a-7a9a-465f-929f-0b5c934b83f2">

**일반버스 아이콘입니다.**

 <img width="72" alt="스크린샷 2023-06-20 오후 11 36 55" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/1c51798c-ba76-44d8-81cf-dbb040da5be0"> 

 **광역버스 아이콘입니다.**

<img width="71" alt="스크린샷 2023-06-20 오후 11 36 48" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/caca8c69-22c0-4fef-88a7-dc99568603d7">

**마을버스 아이콘입니다.**

## 기여(Contributing)
Contributions are very welcome 🙌 

기여는 누구나 환영입니다. 🙌


## License
누구나 활용 가능합니다.

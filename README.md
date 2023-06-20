<p align="center">
   <img width="200" src="app/Assets.xcassets/AppIcon.appiconset/1024.png" alt="APP Logo">
</p>
<p align="center">    ###나주 버스 </p>
<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.8-orange.svg?style=flat" alt="Swift 5.8">
   </a>
   <a href="https://www.apple.com/kr/app-store/">
      <img src="https://img.shields.io/badge/App%20Store-Download%20on%20App%20Store-blue.svg?style=flat" alt="App Store">
   </a>
   <img src="https://img.shields.io/badge/iOS-16%2B-brightgreen.svg?style=flat" alt="iOS 16+ Compatible">
</p>


# 나주 버스(Naju Bus)

나주시 시민들을 위한 버스 도착 정보를 제공하는 어플로써 버스 정류장을 검색하고 버스 도착까지 남은 시간을 알려주는 기능을 제공합니다.

## 기능(Features)

- [x] ℹ️ 정류장 데이터 부착
- [x] ℹ️ 정류장 검색
- [x] ℹ️ 도착 시간 제공
- [x] ℹ️ 즐겨 찾기 기능
- [x] ℹ️ 디자인 개선 
- [ ] ℹ️ 다른 언어 지원
- [ ] ℹ️ 다양한 검색 기능


## 파일(File)

#### Main View.swift
- 앱 실행시 보이는 메인 화면입니다. \n
  버스 정류장을 검색하는 기능을 가지고 있습니다.
#### searchBus.swift
- 정류장 정보를 검색하는 기능을 가지고 있습니다.
#### searchResultView.swift
- 버스 정류장 이름을 기반으로 CoreData에서 정류장 정보를 검색하고 \n
  해당 정류장의 도착 정보를 표시하는 기능을 가지고 있습니다.
#### DB.swift
- CoreData의 저장, 삭제 기능을 가지고 있습니다.
#### DB view.swift
- CoreData에서 가져온 정류소 정보를 표시합니다.
  DB.swift의 생성 삭제 기능을 제어합니다.
#### PersistenceController.swift
- CoreData를 설정하고 영구 저장소를 로드합니다.
#### app.xcdatamodeld
- CoreData의 저장소입니다.

## Installation

앱스토어에 등록 예정입니다.
현재 IPhone12(IOS16.5) 환경에서 정상 테스트 완료했습니다.


## Usage
## Usage
| 사진 | 사진 |
| --- | --- |
| ![사진1](https://github.com/UNGGU0704/Naju_busInfo/raw/main/assets/130115689/6227cf8e-8df4-4fed-b4c8-ec5bc75f3ff7.png) | 
| ![사진2](https://github.com/UNGGU0704/Naju_busInfo/raw/main/assets/130115689/448ffefa-3433-4e73-9130-ef0a34799f40.png) |
| 제목1 | 제목2 |
| ![사진3](https://github.com/UNGGU0704/Naju_busInfo/raw/main/assets/130115689/b01aafbf-a63f-488e-a617-a36171772b20.png) |
| ![사진4](https://github.com/UNGGU0704/Naju_busInfo/raw/main/assets/130115689/84af66cf-bed0-40ab-81c8-aa49af708ef5.png) |
| 제목3 | 제목4 |






## Contributing
Contributions are very welcome 🙌 \n
기여는 누구나 환영입니다. 🙌


## Contributing
누구나 활용 가능합니다.

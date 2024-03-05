# 새싹톡 - Sesac Service Level Project

## 프로젝트 소개 

- 새싹(Sesac)의 마지막 프로젝트 Service Level Project인 새싹톡입니다. 협업툴인 잔디앱을 기반으로 제작된 프로젝트 입니다.
- 개발기간: 2024.01.02 ~ 2024.02.29
- 1인 프로젝트/서버 및 디자인은 Sesac에서 제공
- 현재는 서버 종료로 인해 앱을 실행 시킬 수 없습니다.

## 주요 화면 및 기능

### 로그인 및 회원가입
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/92fc0fe8-409c-42b2-bd13-888d115c0c92" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/6190e9c1-461e-4ee5-a780-419262d406f7" width="200" height="433">

### 워크스페이스 및 채팅
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/55300338-9e5c-4c85-9147-c2c49c61526b" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/f2f21785-df49-49c0-a6b5-3f018e46b0bf" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/3c087807-8b14-42bf-a6ba-bb7452e4029d" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/f1f6c125-3f37-4aad-a335-7be15e4bce97" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/84f7d66b-203c-4b33-885e-0e576652ea3b" width="200" height="400">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/ebe12ea2-286e-48b6-9f92-c70c8a580093" width="200" height="400">

### 회원정보 관리 및 결제
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/d810bc25-fef6-45e7-8880-c28517f34994" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/99f3f276-8b5c-447f-800e-e0622544f5f6" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/02e34df8-2003-4a1e-b51e-c6b5394e307f" width="200" height="433">

- 로그인, 소셜 로그인 및 회원가입
- 워크스페이스 생성, 삭제, 편집
- 채널(채팅방) 생성, 삭제, 편집, 채팅
- 특정 유저에게 DM 기능
- 워크스페이스 유저 초대 기능
- 유저 프로필 수정
- 결제 기능

## 개발 환경 및 기술 스택

|목적|기술 스택|
|------|---|
|최소 버전|16.0|
|DB|Realm|
|UI 프레임워크|SwiftUI, UIKit|

## 사용 라이브러리

|사용 목적|라이브러리|
|------|---|
|비동기 처리, 동시성 관리|swift concurrency, Combine|
|DI|Swinject|
|소켓 통신|Socket.IO|
|네트워크|Alamofire|
|결제|Iamport|

## 아키텍처

![SLPArch](https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/e3613e54-c527-4d17-a5d0-436708a68282)

전체적으로 유지되어야 하는 상태값(로그인 상태, 유저 프로필 등등), 또는 데이터를 관리하기 위해 AppState라는 객체를 두어 이를 관리. 많은 API를 사용하는 기능을 보다 수월하게 개발하기 위해, 이를 Usecase와 Repository로 추상화를 진행하여 Presentation계층과 Domain계층, Data계층을 나누었음.

# 트러블 슈팅 및 도전

## Alamofire의 Response Serializer을 Custom하여 응답값 핸들링

로그인을 한 후 AccessToken을 재발급 받아야 할때, 기존에는 interceptor를 이용하여 이를 처리했지만 다음과 같이 statusCode가 같고 body의 errorCode로 에러를 판단 해야 할때, interceptor의 retry 메소드는 인자값으로 response의 값을 제공해 주지 않기 때문에 interceptor만으로 응답값을 처리 할 수 없었음. 

|Status Code|에러 원인|에러 body값|
|------|---|--|
|400|알맞지 않은 서버 키 값|"errorCode": "1"|
|400|옳바르지 않는 경로|"errorCode": "2"|
|400|Access Token 시간 만료|"errorCode": "3"|

이를 해결하기 위해 Alamofire가 어떤 방식으로 응답의 유효성을 검증하는지를 내부 코드를 뜯어 보아서 validate와 response함수에서 유효성을 검증하는 것을 알았고, 보다 상세한 유효성을 검증하기 위해 response를 커스텀 하는 방식으로 이 문제를 해결.

```swift
func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        guard error == nil, let response else { throw error! }
        guard let data, !data.isEmpty else {
            return try responseEmpty(request: request, response: response)
        }
        if !acceptableStatusCode.contains(response.statusCode) {
            let errorCode = try decoder.decode(SLPErrorModel.self, from: data).errorCode
            try mappingError(errorCode: errorCode)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
    }
```


## State에 변화가 생길 시 View가 초기화 되던 문제

<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/c9048477-0137-44c3-aafc-61dfcc12e953" width="200" height="433">

원인: 기존 ImageView는 외부로부터 url을 받아서 onAppear메소드를 통해 이미지를 가져오는 방식이었으나, 해당 워크스페이스를 담고 있는 셀이 State를 가지고 있고, EnvironmentObject가 변경됨에 따라 State가 초기화 되어 생긴 문제.

```swift
struct SideMenuWorkspaceListView: View {
    let workspaceList: [WorkspaceThumbnailModel]
    @State private var selection: UUID?
    @EnvironmentObject var appState: AppState
```

해결: subView가 가지고 있는 State를 제거, ParentsView가 State를 가지고 있고, subView는 부모로 부터 State를 받아오는 방식으로 구현함으로써 문제를 해결. SwiftUI의 View가 다시 그려지는 과정, 원리에 대해 이해를 할 수 있게 해주었던 문제.

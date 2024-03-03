# 새싹톡 - Sesac Service Level Project

## 프로젝트 소개 

새싹(Sesac)의 마지막 프로젝트 Service Level Project인 새싹톡입니다. 협업툴인 잔디앱을 기반으로 제작된 프로젝트 입니다.

## 주요 화면 

### 인증
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/92fc0fe8-409c-42b2-bd13-888d115c0c92" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/6190e9c1-461e-4ee5-a780-419262d406f7" width="200" height="433">

### 워크스페이스 및 채팅
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/55300338-9e5c-4c85-9147-c2c49c61526b" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/f2f21785-df49-49c0-a6b5-3f018e46b0bf" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/3c087807-8b14-42bf-a6ba-bb7452e4029d" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/f1f6c125-3f37-4aad-a335-7be15e4bce97" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/84f7d66b-203c-4b33-885e-0e576652ea3b" width="200" height="400">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/ebe12ea2-286e-48b6-9f92-c70c8a580093" width="200" height="400">

### 회원정보 관리
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/d810bc25-fef6-45e7-8880-c28517f34994" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/SesacTalk/assets/58679737/99f3f276-8b5c-447f-800e-e0622544f5f6" width="200" height="433">

## 개발 환경 및 기술 스택

|목적|기술 스택|
|------|---|
|최소 버전|16.0|
|DB|Realm|
|UI 프레임워크|SwiftUI|

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

전체적으로 유지되어야 하는 상태값(로그인 상태, 유저 프로필 등등), 또는 데이터를 관리하기 위해 AppState라는 객체를 두어 이를 관리. 

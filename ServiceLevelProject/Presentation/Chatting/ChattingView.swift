//
//  ChattingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/27.
//

import SwiftUI

struct ChattingView: View {
    @State var inputText: String = ""
    @StateObject var imagePickerModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    @StateObject var msgMoel: MessageViewModel = .init()
    @FocusState private var isFocus: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(msgMoel.messages) { msg in
                            ChatBubble(message: msg)
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }.onTapGesture {
                    isFocus = false
                }
                ChattingBarView(text: $inputText, imagePickerModel: imagePickerModel, isFocus: $isFocus) { message in
                    msgMoel.writeMessage(message: message)
                }
            }
            
        }
    }
}

struct Message: Identifiable {
    let id: UUID = UUID()
    var message: String?
    var photo: [String]
    var profilePath: String?
    var myMsg: Bool
    var time: Date
    var username: String
}

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    func writeMessage(message: Message) {
        messages.append(message)
    }
}

#Preview {
    ChattingView()
}

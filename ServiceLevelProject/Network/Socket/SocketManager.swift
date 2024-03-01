//
//  SocketManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import SocketIO
import Foundation
import Combine

final class SocketIOManager: NSObject {
    
    enum SocketType: String {
        case channel
        case dm
    }
    
    private var manager: SocketManager?
    var socket: SocketIOClient?
    var channelMessageSubject = PassthroughSubject<ChannelChatting, Never>()
    var dmMessageSubject = PassthroughSubject<DMChatting, Never>()
    
    init(id: Int, type: SocketType) {
        super.init()
        createSocket(type: type, id: id)
        socket?.on(clientEvent: .connect) { data, ack in
            print("SUCCESS CONNECT \(data) \(ack)")
        }
        socket?.on(type.rawValue) { data, ack in
            do {
                let originData = data[0]
                let dat = try JSONSerialization.data(withJSONObject: originData)
                print(String(decoding: dat, as: UTF8.self))
                if type == .channel {
                    let res = try JSONDecoder().decode(ChannelChattingResponseDTO.self, from: dat)
                    self.channelMessageSubject.send(try res.toDomain())
                } else {
                    let res = try JSONDecoder().decode(DMChattingResponseDTO.self, from: dat)
                    let dm = try res.toDomain()
                    self.dmMessageSubject.send(dm)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private func createSocket(type: SocketType, id: Int) {
        guard let baseUrl = URL(string: "http://slp.sesac.kr:27888") else { return }
        guard let SLPAPIKey = Bundle.main.infoDictionary?["SESAC_APP_KEY"] as? String else { return }
        self.manager = SocketManager(socketURL: baseUrl, config: [.log(false), .extraHeaders(["SesacKey":SLPAPIKey, "Authorization":Token.accessToken!])])
        socket = manager?.socket(forNamespace: "/ws-\(type.rawValue)-\(id)")
    }
    
    func connectSocket() {
        socket?.connect()
    }
    
    func closeSocket() {
        socket?.disconnect()
        socket = nil
        manager = nil
    }
    
    func sendMessage(channelChatting: ChannelChattingResponseDTO) {
        guard let data = try? JSONEncoder().encode(channelChatting) else { return }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            socket?.emit("channel", json)
        }
        
    }
}

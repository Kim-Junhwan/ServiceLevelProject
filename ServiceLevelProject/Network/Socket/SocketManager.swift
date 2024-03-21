//
//  SocketManager.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import SocketIO
import Foundation
import Combine

enum SocketType: String {
    case channel
    case dm
}

class SocketIOManager<T: Codable>: NSObject {
    private var manager: SocketManager?
    var socket: SocketIOClient?
    var socketType: SocketType
    
    init(id: Int, type: SocketType) {
        self.socketType = type
        super.init()
        createSocket(type: type, id: id)
        socket?.on(clientEvent: .connect) { data, ack in
            print("SUCCESS CONNECT \(data) \(ack)")
        }
        socket?.on(type.rawValue) { data, ack in
            do {
                let originData = data[0]
                let dat = try JSONSerialization.data(withJSONObject: originData)
                let res = try JSONDecoder().decode(T.self, from: dat)
                self.messageClosure(decodeData: res)
            } catch {
                print(error)
            }
        }
    }
    
    func messageClosure(decodeData: T) {}
    
    private func createSocket(type: SocketType, id: Int) {
        guard let baseUrlStr = Bundle.main.infoDictionary?["SESAC_BASE_URL"] as? String else { return }
        guard let baseUrl = URL(string: baseUrlStr) else { return }
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
    
    func sendMessage(chatting: T) {
        guard let data = try? JSONEncoder().encode(chatting) else { return }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            socket?.emit(socketType.rawValue, json)
        }
    }
}

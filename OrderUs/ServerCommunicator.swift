//
//  ServerCommunicator.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-19.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import SocketIO

class ServerCommunicator: NSObject {
    
    static let sharedInstance = ServerCommunicator()
    
    struct Constants {
        static let serverIP = "http://192.168.0.29"
        static let connectionEstablished = "connect"
        static let dataNeedsToBeReloaded = "dataNeedsToBeReloaded"
    }
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: Constants.serverIP)!, config: [.forceWebsockets(true)])
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func bootstrap() {
        setupEvents()
        sendNecessaryMessages()
    }
    
    private func setupEvents() {
        setupConnectEvent()
    }
    
    private func setupConnectEvent() {
        socket.on(Constants.connectionEstablished) { [unowned uoSelf = self] (data, ack) in
            print("connected to server at ip \(Constants.serverIP)")
            uoSelf.socket.emit(Constants.dataNeedsToBeReloaded, with: ["poasidpsaoidpsoaid"])
        }
    }
    
    private func sendNecessaryMessages() {
        sendMessageTocheckIfDataNeedsToBeReloaded()
    }
    
    private func sendMessageTocheckIfDataNeedsToBeReloaded() {
        socket.emitWithAck(Constants.dataNeedsToBeReloaded, with: []).timingOut(after: 10) { data in
            print("here: \(data)")
        }
    }
}

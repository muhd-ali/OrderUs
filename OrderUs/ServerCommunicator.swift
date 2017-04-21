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
        static let serverIP = "http://192.168.0.28"
        static let connectionEstablished = "connect"
        static let checkIfDataNeedsToBeReloaded = "dataNeedsToBeReloaded"
        static let connectionLost = "disconnect"
    }
    
    let socket: SocketIOClient = SocketIOClient(
        socketURL: URL(string: Constants.serverIP)!,
        config: [
            .forcePolling(true),
            .reconnects(true),
            .reconnectWait(5),
            ]
    )
    
    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }
    
    func bootstrap() {
        setupMainEvents()
        socket.connect()
    }
    
    private func setupMainEvents() {
        setupConnectEvent()
        setupDisconnectEvent()
        setupAppEvents()
    }
    
    private func setupAppEvents() {
        setupEventTocheckIfDataNeedsToBeReloaded()
    }
    
    private func requestReloadData() {
        
    }
    
    private func setupEventTocheckIfDataNeedsToBeReloaded() {
        socket.on(Constants.checkIfDataNeedsToBeReloaded) { [unowned uoSelf = self] (data, ack) in
            let dataNeedsToBeReloaded = data[0] as! Bool
            if dataNeedsToBeReloaded {
                uoSelf.requestReloadData()
            }
        }
    }
    
    private func setupConnectEvent() {
        socket.on(Constants.connectionEstablished) { [unowned uoSelf = self] (data, ack) in
            uoSelf.sendNecessaryMessages()
        }
    }
    
    private func setupDisconnectEvent() {
        socket.on(Constants.connectionLost) { [unowned uoSelf = self] (data, ack) in
            uoSelf.socket.off(Constants.connectionEstablished)
        }
    }
    
    private func sendNecessaryMessages() {
        sendMessageTocheckIfDataNeedsToBeReloaded()
    }
    
    private func sendMessageTocheckIfDataNeedsToBeReloaded() {
        socket.emit(Constants.checkIfDataNeedsToBeReloaded, with: [""])
    }
}

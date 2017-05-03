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
        static let serverIP = "http://192.168.0.222"
        static let connectionEstablished = "connect"
        static let checkIfDataNeedsToBeReloaded = "dataNeedsToBeReloaded"
        static let connectionLost = "disconnect"
        static let itemsList = "itemsList"
        static let categoriesList = "categoriesList"
        static let newOrder = "newOrder"
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
    
    internal func setupMainEvents() {
        setupConnectEvent()
        setupDisconnectEvent()
        setupAppEvents()
    }
    
    internal func setupAppEvents() {
        setupEventTocheckIfDataNeedsToBeReloaded()
        setupEventToReceiveItemsList()
        setupEventToReceiveCategoriesList()
    }
    
    internal func requestReloadItemsData() {
        socket.emit(Constants.itemsList, with: [""])
    }
    
    internal func requestReloadCategoriesData() {
        socket.emit(Constants.categoriesList, with: [""])
    }
    
    internal func setupEventToReceiveItemsList() {
        socket.on(Constants.itemsList) { (data, ack) in
            if let items = data[0] as? [[String : Any]] {
                DataManager.sharedInstance.itemsRaw = items
            }
        }
    }
    
    internal func setupEventToReceiveCategoriesList() {
        socket.on(Constants.categoriesList) { (data, ack) in
            if let categories = data[0] as? [[String : Any]] {
                DataManager.sharedInstance.categoriesRaw = categories
            }
        }
    }
    
    internal func setupEventTocheckIfDataNeedsToBeReloaded() {
        socket.on(Constants.checkIfDataNeedsToBeReloaded) { [unowned uoSelf = self] (data, ack) in
            let dataNeedsToBeReloaded = data[0] as! Bool
            if dataNeedsToBeReloaded {
                uoSelf.requestReloadItemsData()
                uoSelf.requestReloadCategoriesData()
            }
        }
    }
    
    internal func setupConnectEvent() {
        socket.on(Constants.connectionEstablished) { [unowned uoSelf = self] (data, ack) in
            uoSelf.sendNecessaryMessages()
        }
    }
    
    internal func setupDisconnectEvent() {
        socket.on(Constants.connectionLost) { [unowned uoSelf = self] (data, ack) in
            uoSelf.socket.off(Constants.connectionEstablished)
        }
    }
    
    internal func sendNecessaryMessages() {
        sendMessageTocheckIfDataNeedsToBeReloaded()
    }
    
    internal func sendMessageTocheckIfDataNeedsToBeReloaded() {
        socket.emit(Constants.checkIfDataNeedsToBeReloaded, with: [""])
    }
    
    func placeOrder() {
            let jsonData = ShoppingCartModel.sharedInstance.cartItems.map({ $0.jsonData })
            socket.emit(Constants.newOrder, with: [jsonData])
    }
}

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
        static let serverIP = "http://192.168.0.105"
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
    
    private func setupMainEvents() {
        setupConnectEvent()
        setupDisconnectEvent()
        setupAppEvents()
    }
    
    private func setupAppEvents() {
        setupEventTocheckIfDataNeedsToBeReloaded()
        setupEventToReceiveItemsList()
        setupEventToReceiveCategoriesList()
    }
    
    private func requestReloadItemsData() {
        socket.emit(Constants.itemsList, with: [""])
    }
    
    private func requestReloadCategoriesData() {
        socket.emit(Constants.categoriesList, with: [""])
    }
    
    private func setupEventToReceiveItemsList() {
        socket.on(Constants.itemsList) { (data, ack) in
            if let items = data[0] as? [[String : Any]] {
                DataManager.sharedInstance.rawItems = items
            }
        }
    }
    
    private func setupEventToReceiveCategoriesList() {
        socket.on(Constants.categoriesList) { (data, ack) in
            if let categories = data[0] as? [[String : Any]] {
                DataManager.sharedInstance.rawCategories = categories
            }
        }
    }
    
    private func setupEventTocheckIfDataNeedsToBeReloaded() {
        socket.on(Constants.checkIfDataNeedsToBeReloaded) { [unowned uoSelf = self] (data, ack) in
            let dataNeedsToBeReloaded = data[0] as! Bool
            if dataNeedsToBeReloaded {
                uoSelf.requestReloadItemsData()
                uoSelf.requestReloadCategoriesData()
            } else {
                DataManager.sharedInstance.loadDataFromDB()
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
    
    func placeOrder() {
            let jsonData = ShoppingCartModel.sharedInstance.order.jsonData
            socket.emit(Constants.newOrder, with: [jsonData])
    }
}

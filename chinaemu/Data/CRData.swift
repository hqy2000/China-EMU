//
//  CRData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache

class CRData: ObservableObject {
    let crProvider =  AbstractProvider<CRRequest>();
    let moeRailProvider = AbstractProvider<MoerailRequest>();
    @Published var leftTickets: [LeftTicketInfo] = []
    @Published var emus: [EMU] = []
    
    public func getLeftTickets(from: String, to: String, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        crProvider.request(target: .leftTicketPrice(from: from, to: to, date: dateFormatter.string(from: date)), type: CRResponse<[LeftTicketInfo]>.self) { (result) in
            print(result)
            self.leftTickets = result.data
            self.moeRailProvider.request(target: .trains(keywords: result.data.map({ $0.leftTicket.trainNo })), type: [EMU].self, success: { (emus) in
                self.emus = emus
            })
        }
    }
}

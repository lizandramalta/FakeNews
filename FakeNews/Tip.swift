//
//  Tip.swift
//  FrameworksSwift
//
//  Created by Daniela Valadares on 19/10/25.
//

import Foundation
import TipKit

struct CreateNewReport: Tip {
    var title: Text {
        Text("Gere uma nova notícia")
    }
    
    var message: Text? {
        Text("Clique aqui para gerar uma nova notícia para os usuários")
    }
    
    var image: Image? {
        Image(systemName: "newspaper")
    }
}

struct SeeMoreReports: Tip {
    static let tapReportEvent = Event(id: "tapReport")
    static let viewReportEvent = Event(id: "viewReport")
    
    var title: Text {
        Text("Leia sobre as notícias")
    }
    
    var message: Text? {
        Text("Clique na notícia para lê-la completa")
    }
    
    var image: Image? {
        Image(systemName: "hand.tap.fill")
    }
    
    var rules: [Rule] {
        #Rule(Self.tapReportEvent) { event in
            event.donations.count == 0
        }
        
        #Rule(Self.viewReportEvent) { event in
            event.donations.count > 2
        }
    }
}

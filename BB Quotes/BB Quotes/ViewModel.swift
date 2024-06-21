//
//  ViewModel.swift
//  BB Quotes
//
//  Created by ulixe on 24/04/24.
//

import Foundation

// deve stare sul main thread
@MainActor
class ViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success(data: (quote: Quote, character: Character))
        case failed(error: Error)
    }
    // è praticamente il setter di java, rende visibile la property alla view ma non le permette di cambiarne il valore
    @Published private(set) var status: Status = .notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
    }
    
    func getData(for show: String) async {
        status = .fetching
        
        do {
            let quote = try await controller.fetchQuote(from: show)
            
            let character = try await controller.fetchCharacter(quote.character)
            
            status = .success(data: (quote, character))
        } catch {
            status = .failed(error: error)
        }
    }
}

//
//  NewsViewModel.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import Foundation

@MainActor
@Observable
final class NewsViewModel {
    private let repo: NewsRepository
    
    var news: [News] = []
    var isLoading = false
    var lastError: String?
    
    init(repo: NewsRepository) {
        self.repo = repo
        Task { await refresh() }
    }
    
    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await Task.sleep(for: .seconds(2))
            news = try await repo.fetchAll()
        } catch {
            lastError = "❌ Erro ao buscar: \(error.localizedDescription)"
        }
    }
    
//    func add(news: News) async {
//        do {
//            try await repo.add(news)
//            await refresh()
//        } catch {
//            lastError = "❌ Erro ao criar: \(error.localizedDescription)"
//        }
//    }
    
    func add(news newItem: News) async {
        do {
            news.insert(newItem, at: 0)
            try await repo.add(newItem)
        } catch {
            lastError = "❌ Erro ao criar: \(error.localizedDescription)"
        }
    }
    
    // Tem essa opção que faz 2 requisições para a rede gasta mais bateria e processamento mas funciona normalmente.
    
//    func delete(news: News) async {
//        do {
//            try await repo.delete(news)
//              print("🗑️ Pedido de deleção enviado para \(news.id)")
//            await refresh()
//        } catch {
//              print("❌ Erro ao deletar:", error)
//            lastError = "❌ Erro ao deletar: \(error.localizedDescription)"
//        }
//    }
    
    // Esse faz apenas 1 requisição na rede e depois apaga da memoria do aparelho nao precisando fazer outra requisição e gastando bateria e processamento.
    
    func delete(news itemDelete: News) async {
        do {
            try await self.repo.delete(itemDelete)
            news.removeAll { $0.id == itemDelete.id }
        } catch {
            lastError = "❌ Erro ao deletar: \(error.localizedDescription)"
        }
    }
}

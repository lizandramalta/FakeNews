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
            news = try await repo.fetchAll()
        } catch {
            lastError = "❌ Erro ao buscar: \(error.localizedDescription)"
        }
    }
    
    func add(news: News) async {
        do {
            try await repo.add(news)
            await refresh()
        } catch {
            lastError = "❌ Erro ao criar: \(error.localizedDescription)"
        }
    }
}

//
//  CloudKitNewsRepository.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import CloudKit

protocol NewsRepository {
    func checkAvailability() async -> CloudKitStatus
    func fetchAll() async throws -> [News]
    func add(_ news: News) async throws -> Void
}

final class CloudKitNewsRepository: NewsRepository {
    private let ck: CloudKitClient
    
    init(ck: CloudKitClient) { self.ck = ck }
    
    func checkAvailability() async -> CloudKitStatus {
        await ck.accountStatus()
    }
    
    func fetchAll() async throws -> [News] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "News", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let records = try await ck.query(query, desiredKeys: nil)
        return records.compactMap(News.init(record:))
    }
    
    func add(_ news: News) async throws {
        try await ck.save(news.toRecord())
    }
}

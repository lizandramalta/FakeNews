//
//  CloudKitClient.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import CloudKit

enum CloudKitStatus {
    case ok, noAccount, restricted, unknown
}

protocol CloudKitClient {
    func accountStatus() async -> CloudKitStatus
    func save(_ record: CKRecord) async throws -> Void
    func query(_ query: CKQuery,
               desiredKeys: [String]?) async throws -> [CKRecord]
    
    var publicDB: CKDatabase { get }
}

final class DefaultCloudKitClient: CloudKitClient {
    private let container: CKContainer = CKContainer.default()
    let publicDB: CKDatabase
    
    init() {
        self.publicDB = container.publicCloudDatabase
    }
    
    func accountStatus() async -> CloudKitStatus {
        do {
            let status = try await container.accountStatus()
            switch status {
            case .available: return .ok
            case .noAccount: return .noAccount
            case .restricted: return .restricted
            default: return .unknown
            }
        } catch {
            return .unknown
        }
    }
    
    func save(_ record: CKRecord) async throws -> Void {
        try await publicDB.save(record)
    }
    
    func query(_ query: CKQuery,
               desiredKeys: [String]? = nil) async throws -> [CKRecord] {
        return try await withCheckedThrowingContinuation { cont in
            let op = CKQueryOperation(query: query)
            op.desiredKeys = desiredKeys
            var results: [CKRecord] = []
            op.recordMatchedBlock = { _, result in
                switch result {
                case .success(let record):
                    results.append(record)
                case .failure(let error):
                    print("❌ Erro ao executar query:", error)
                }
            }
            op.queryResultBlock = { _ in
                cont.resume(returning: results)
            }
            publicDB.add(op)
        }
    }
}

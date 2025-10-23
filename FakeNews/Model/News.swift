//
//  News.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import CloudKit

struct News: Identifiable, Hashable {
    let id: CKRecord.ID
    var title: String
    var description: String
    var publishedAt: Date?
}

extension News {
    init?(record: CKRecord) {
        guard
            let title = record["title"] as? String,
            let description = record["description"] as? String
        else { return nil }
        
        self.id = record.recordID
        self.title = title
        self.description = description
        self.publishedAt = record.creationDate
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "News", recordID: id)
        record["title"] = title as String
        record["description"] = description as String
        return record
    }
}

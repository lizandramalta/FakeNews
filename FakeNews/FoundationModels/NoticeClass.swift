//
//  NoticeClass.swift
//  Challenge09
//
//  Created by Ana Clara Ferreira Caldeira on 20/10/25.
//

import Foundation
import SwiftData

@Model
class NoticeClass: Identifiable {
	var id: UUID
	var title: String
	var nDescription: String
	
	init(title: String, nDescription: String) {
		self.id = UUID()
		self.title = title
		self.nDescription = nDescription
	}
}

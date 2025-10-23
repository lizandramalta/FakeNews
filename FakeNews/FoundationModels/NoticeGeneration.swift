//
//  NoticeGeneration.swift
//  Challenge09
//
//  Created by Ana Clara Ferreira Caldeira on 17/10/25.
//

import FoundationModels
import Foundation
import Combine

@MainActor
class NoticeGeneration: ObservableObject {
	private let session: LanguageModelSession
	
	init() {
		let instructions = """
			Você é um jornalista profissional criando novas histórias pequenas e ficcionais.
				Siga esse formato:
				- Foque nos mais variados tópicos: ciência, economia, tecnologia, saúde e entretenimento.
				- Use um tom realista, como se fosse uma notícia real.
				- Invente os nomes de instituições, lugares, pessoas e pode colocar notícias absurdas sem sentido.
				- Os eventos devem ser ficcionais e absurdos.

			"""
		
		session = LanguageModelSession(instructions: instructions)
	}
	
	func generateNoticeStreaming() async throws -> News {
		var noticeStruct = NoticeStruct(title: "", description: "")
        
        var news = News(id: .init(recordName: UUID().uuidString), title: "", description: "")
		for try await partial in session.streamResponse(to: "Gere um artigo de noticia ficional aleatorio.", generating: NoticeStruct.self) {
			if let title = partial.content.title { noticeStruct.title = title }
			if let description = partial.content.description { noticeStruct.description = description }
			
            news = News(id: .init(recordName: UUID().uuidString), title: noticeStruct.title, description: noticeStruct.description)
		}
		
		return news
	}
}

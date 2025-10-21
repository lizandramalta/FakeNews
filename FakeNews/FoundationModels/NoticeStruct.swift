//
//  Notice.swift
//  Challenge09
//
//  Created by Ana Clara Ferreira Caldeira on 17/10/25.
//

import FoundationModels
import Foundation

@Generable(description: "Gere um pequeno artigo de uma noticia aleatoria e ficcional")
struct NoticeStruct: Equatable {
	
	@Guide(description: "Título da notícia curta, claro e impactante.")
	var title: String
	
	@Guide(description: "Breve parágrafo com detalhes do evento inventado, em tom jornalístico alarmante")
	var description: String
	
}

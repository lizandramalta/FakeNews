//
//  MockData.swift
//  GraficosApp
//
//  Created by Késia Silva Viana on 18/10/25.
//

import Foundation
import SwiftUI

struct Data: Identifiable {
	let id = UUID()
	let date: Date
	let viewCount: Int
	let name: String //adicionado para testar o gráfico de pizza
	
	static let mockData: [Data] = [
		.init(date: Date.from(year: 2025, month: 01, day: 01), viewCount: 1340, name: "Jan"),
		.init(date: Date.from(year: 2025, month: 02, day: 01), viewCount: 3245, name: "Fev"),
		.init(date: Date.from(year: 2025, month: 03, day: 01), viewCount: 6785, name: "Mar"),
		.init(date: Date.from(year: 2025, month: 04, day: 01), viewCount: 2889, name: "Abr"),
		.init(date: Date.from(year: 2025, month: 05, day: 01), viewCount: 3472, name: "Mai"),
		.init(date: Date.from(year: 2025, month: 06, day: 01), viewCount: 7773, name: "Jun"),
		.init(date: Date.from(year: 2025, month: 07, day: 01), viewCount: 2203, name: "Jul"),
		.init(date: Date.from(year: 2025, month: 08, day: 01), viewCount: 6646, name: "Ago"),
		.init(date: Date.from(year: 2025, month: 09, day: 01), viewCount: 1030, name: "Set"),
		.init(date: Date.from(year: 2025, month: 10, day: 01), viewCount: 3256, name: "Out"),
		.init(date: Date.from(year: 2025, month: 11, day: 01), viewCount: 3321, name: "Nov"),
		.init(date: Date.from(year: 2025, month: 12, day: 01), viewCount: 3321, name: "Dez")
	]
}

extension Date { //extensao para exibir a data com base naquele ano, mes, dia que eu passo.
	static func from(year: Int, month: Int, day: Int) -> Date {
		var components = DateComponents() //depois crio um objeto com base naqueles dados que passei
		components.year = year
		components.month = month
		components.day = day
		return Calendar.current.date(from: components)!
	}
}

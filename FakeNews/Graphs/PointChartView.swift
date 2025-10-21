//
//  LineChartView.swift
//  GraficosApp
//
//  Created by Késia Silva Viana on 18/10/25.
//

import SwiftUI
import Charts

struct PointChartView: View {
	var mockData = Data.mockData
	
	@State private var rawSelectionDate: Date?//propriedade criada para usar nas interacoes
	
	var selectedViewMonth: Data? {
		guard let rawSelectionDate else { return nil }
		return mockData.first{
			Calendar.current.isDate(rawSelectionDate, equalTo: $0.date, toGranularity: .month)
		}
	}
	
	var body: some View {
		VStack (alignment: .leading, spacing: 4){
			
			//criando uma descricao do grafico:
			Text("Gastos Mensais")
			Text("Ano atual: 2025")
				.fontWeight(.semibold)
				.font(.footnote)
				.foregroundColor(.secondary)
				.padding(.bottom, 12)
			
			
			Chart{ //criado o grafico a partir dos dados da matriz que criamos
				
				//criando um if para a UI das barras de quando selecionamos cada uma:
				if let selectedViewMonth {
					RuleMark(x: .value("Selected Month", selectedViewMonth.date, unit: .month))
						.foregroundStyle(.secondary.opacity(0.3))//personalizando a linha
					//criando a UI que ficara por cima da linha
						.annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
							VStack{
								Text(selectedViewMonth.date, format: .dateTime.month(.wide))
									.bold()
								
								Text("\(selectedViewMonth.viewCount)")
								.font(.title3.bold())
							}
							//personalizando o tamanho do quadro que exibirá quando segurar na barra
							.foregroundStyle(.white)
							.padding(12)
							.frame(width: 120)
							.background(RoundedRectangle(cornerRadius: 10).fill(.pink.gradient))
						}
				}
				ForEach(mockData) { viewDado in
					//criadno uma vizualizacao de grafico do tipo de barras
					PointMark(
						x: .value("Ano", viewDado.date, unit: .month),
						y: .value("Dados", viewDado.viewCount)
						)
					//criando uma personalizacao básica:
					.foregroundStyle(Color.pink.gradient)
					//adicionando a opacidade quando clica na barra:
					.opacity(rawSelectionDate == nil || viewDado.date == selectedViewMonth? .date ? 1 : 0.5)
					
					
				}//tudo isso atua como uma ZStack ou seja posso estabelecer as regras atras das barras do meu grafico
			}
			
			
			.frame(height: 180)  //definindo um tamanho para o gráfico
			
			//criando o drang in drop que passa por cima de cada barra do grafico:
			.chartXSelection(value: $rawSelectionDate.animation(.easeInOut))
			.chartXAxis{ //personaliza o eixo X
				AxisMarks(values: mockData.map { $0.date }) { date in
					AxisGridLine() //adiciona linhas como uma grade
					AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
				}
			}
	
			.chartYAxis{//personaliza o eixo Y
				AxisMarks{ mark in
					AxisValueLabel()
					AxisGridLine()
				}
				
			}
 
			//adicionando tipo uma anotacao
			.padding(.bottom) //deixa mais separado a descrição
			HStack{
				Image(systemName: "line.diagonal") //simbolo
					.rotationEffect(Angle(degrees: 45)) //virando o simbolo
					.foregroundColor(.mint)
				
				Text("Montantes Totais") //exemplo de descricao
					.foregroundColor(.secondary)
			}
			.font(.caption2)
			.padding(.leading, 4)
		}
		.padding()
	}
}

#Preview {
	PointChartView()
}

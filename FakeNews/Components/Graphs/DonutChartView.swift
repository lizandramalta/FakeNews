//
//  DonutChartView.swift
//  GraficosApp
//
//  Created by Késia Silva Viana on 18/10/25.
//

import SwiftUI
import Charts

public struct DonutChartView: View {
    var mockData = Data.mockData
    
   public var body: some View {
        NavigationStack{
            VStack{
                Chart{
                    ForEach(mockData) { stream in
                        SectorMark(angle: .value("Stream", stream.viewCount),
                                   innerRadius: .ratio(0.618), //tamanho do raio interno
//                                   outerRadius: stream.name == "Mar" ? 180 : 120, //quando quer apresentar um pedaço específico
                                   angularInset: 1.0)//tamanho das bordas
//                        .foregroundStyle(stream.color) //se quiser cor personalizada
                            .foregroundStyle(by: .value("month", stream.name))//colocando as cores diferentes de acordo com o nome
                            .cornerRadius(6) //bordas
                            
                    }
                }
//                .chartLegend(.hidden) //tira a legenda automatica do gráfico
                .frame(width: 300, height: 300) //tamanho do grafico
            }
            .padding()
        }
        
    }
}
#Preview {
    DonutChartView()
}

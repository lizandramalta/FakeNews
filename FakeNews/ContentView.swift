import SwiftUI

struct ContentView: View {
    
    @Environment(NewsViewModel.self) private var vm
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var generator = NoticeGeneration()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedNotice: News?
    
    @State var flushUI: Bool = false
    
    var body: some View {
        NavigationStack {
            
            if vm.isLoading {
                VStack{
                    Spacer()
                    ProgressView("Carregando...")
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Notícias")
                                .font(.title2.bold())
                            
                            if vm.news.isEmpty {
                                Text("Toque em 'Gerar Notícia' para começar.")
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(vm.news) { notice in
                                            Button {
                                                selectedNotice = notice
                                            } label: {
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text(notice.title)
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.primary)
                                                        .lineLimit(2)
                                                    
                                                        .padding(.bottom, 3)
                                                    
                                                    Text(notice.description)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                        .lineLimit(7)
                                                    
                                                    Spacer()
                                                }
                                                
                                                .padding()
                                                .frame(width: 300, height: 250 , alignment: .leading)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(16)
                                                .shadow(radius: 3, y: 2)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                        }
                        
                        // MARK: - Gráficos
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Estatísticas")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    // Você pode adicionar vários gráficos aqui
                                    ForEach(0..<3, id: \.self) { _ in
                                        BarChartView()
                                            .padding(10)
                                            .frame(width: 300, height: 300)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(16)
                                            .shadow(radius: 3, y: 2)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button(action: {
                            Task {
                                await generateNotice()
                            }
                            
                        }) {
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Gerar Notícia Aleatória")
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isLoading)
                    }
                    
                    .padding()
                    .navigationDestination(item: $selectedNotice) { notice in
                        NoticePageView(notice: notice)
                    }
                    
                }
                .refreshable {
                    Task{
                        await vm.refresh()
                    }
                }
            }
        }
    }
    
    private func generateNotice() async {
        isLoading = true
        errorMessage = nil
        do {
            let newNotice = try await generator.generateNoticeStreaming()
            Task {
                await vm.add(news: newNotice)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    ContentView()
}

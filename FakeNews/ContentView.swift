import SwiftUI
import SwiftData

struct ContentView: View {
	
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) var dismiss
	
	@Query(sort: \NoticeClass.title) var notices: [NoticeClass]
	
	@StateObject private var generator = NoticeGeneration()
	@State private var isLoading = false
	@State private var errorMessage: String?
	@State private var selectedNotice: NoticeClass?
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				
				// MARK: - Notícias
				if notices.isEmpty {
					Text("Toque em 'Gerar Notícia' para começar.")
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.center)
						.padding()
				} else {
					VStack(alignment: .leading, spacing: 10) {
						Text("Notícias")
							.font(.title2.bold())
							.padding(.horizontal)
						
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 20) {
								ForEach(notices) { notice in
									Button {
										selectedNotice = notice
									} label: {
										VStack(alignment: .leading, spacing: 8) {
											Text(notice.title)
												.font(.headline)
												.foregroundStyle(.secondary)
												.lineLimit(2)
											
											Text(notice.nDescription)
												.font(.subheadline)
												.foregroundStyle(.secondary)
												.lineLimit(3)
										}
										.padding()
										.frame(width: 300, height: 300 , alignment: .leading)
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
	}
	
	private func generateNotice() async {
		isLoading = true
		errorMessage = nil
		
		do {
			let newNotice = try await generator.generateNoticeStreaming()
			modelContext.insert(newNotice)
			try modelContext.save()
		} catch {
			errorMessage = error.localizedDescription
		}
		
		isLoading = false
	}
}

#Preview {
	ContentView()
}

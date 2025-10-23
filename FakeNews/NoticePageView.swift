//
//  NoticePageView.swift
//  Challenge09
//
//  Created by Ana Clara Ferreira Caldeira on 20/10/25.
//

import SwiftUI
import SwiftData

struct NoticePageView: View {
	@Environment(\.dismiss) var dismiss
	
	var notice: News
	
	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 15) {
					Text(notice.title)
						.font(.title.bold())
						.foregroundStyle(.primary)
					
					GeometryReader { geometry in
						JustifiedTextView(text: notice.description)
							.frame(width: geometry.size.width)
					}
				}
				.frame(height: 800)
			}
			.padding()
		}
		.toolbar {
			ToolbarItem(placement: .destructiveAction) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "trash")
						.foregroundStyle(.red)
				}
			}
		}
	}
}


#Preview {
    NoticePageView(notice: News(id: .init(recordName: UUID().uuidString), title: "Title", description: "Description"))
}

//
//  NoticePageView.swift
//  Challenge09
//
//  Created by Ana Clara Ferreira Caldeira on 20/10/25.
//

import SwiftUI
import SwiftData

struct NoticePageView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) var dismiss
	
	var notice: NoticeClass
	
	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 15) {
					Text(notice.title)
						.font(.title.bold())
						.foregroundStyle(.primary)
					
					GeometryReader { geometry in
						JustifiedTextView(text: notice.nDescription)
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
					modelContext.delete(notice)
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
	NoticePageView(notice: NoticeClass(title: "Tile", nDescription: "Description"))
}

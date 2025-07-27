//
//  DiaryPreviewView.swift
//  Diary
//
//  Created by Yurim on 7/28/25.
//

import SwiftUI

struct DiarySectionView: View {
    let title: String
    let subtitle: String
    let content: String

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17))
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 13))
                }
            }
            .frame(width: 52, alignment: .leading)

            Text(content)
                .font(.system(size: 17))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
    }
}

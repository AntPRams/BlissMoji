//
//  ListItemView.swift
//  iMoji
//
//  Created by António Ramos on 08/11/2023.
//

import SwiftUI

struct ListItemView: View {
    
    let repoName: String
    
    var body: some View {
        Text(repoName)
    }
}

#Preview {
    ListItemView(repoName: "test")
}

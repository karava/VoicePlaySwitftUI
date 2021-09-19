//
//  FolderView.swift
//  VoiceRecorderFinished
//
//  Created by Kishan Arava on 15/9/21.
//  Copyright © 2021 Andreas Schultz. All rights reserved.
//

import SwiftUI

struct FolderView: View {
    
    var body: some View {
        ZStack {
            NavigationView  {
                List {
                    NavigationLink(destination: HomeView()) {
                        getRow(title: "All Recordings", systemName: "waveform")
                    }
                    
                    Section(header: Text("My folders")) {
                        ForEach(["test1", "test2"], id: \.self) { foldername in
                            getRow(title: foldername, systemName: "folder")
                        }
                    }
                }
                .navigationBarTitle(Text("Voice Memos"))
                .listStyle(InsetGroupedListStyle())
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                        Button(action: {
                            Alert.titleMessageTextField(title: "New Folder", message: "Enter a name for this folder", placeholder: "Name", defaultText: "", saveActionBtnTitle: "Create") { folderName in
                                print(folderName)
                            }
                        }, label: {
                            Image(systemName: "folder.badge.plus")
                        })
                    }
                }
            }
    
        }
    }
    
    func getRow(title: String, systemName: String) -> some View {
        Label(title, systemImage: systemName)
            .font(.system(size: 20))
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}

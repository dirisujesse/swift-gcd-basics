//
//  ContentView.swift
//  Dates
//
//  Created by Dirisu on 13/04/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: DateListViewModel = DateListViewModel();
     
    var body: some View {
        NavigationView {
            VStack {
                if ((viewModel.viewState == ViewState.error || viewModel.viewState == ViewState.empty) && !viewModel.hasData) {
                    Text(viewModel.message)
                }
                if ((viewModel.viewState == ViewState.loading) && !viewModel.hasData) {
                    ProgressView()
                }
                if (viewModel.viewState == ViewState.loaded || viewModel.hasData) {
                    DateList(currentDates: viewModel.dates)
                }
            }
            .navigationTitle("Dates")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    await viewModel.populateDate();
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
            .task {
                await viewModel.populateDate();
            }
            .refreshable {
                Task {
                    await viewModel.refresh();
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DateTile: View {
    var currentDate: CurrentDate
    
    var body: some View {
        Text(currentDate.date)
            
    }
}


struct DateList: View {
    let currentDates: [CurrentDate]
    
    var body: some View {
        List(currentDates, id: \.id) {
            DateTile(currentDate: $0)
        }
        .listStyle(.plain)
    }
}

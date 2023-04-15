//
//  DateListViewModel.swift
//  Dates
//
//  Created by Dirisu on 13/04/2023.
//

import Foundation

enum ViewState {
    case empty, loading, error, loaded;
}


//extension ViewState: Equatable {
//    public static func ==(base: ViewState, compared: ViewState) -> Bool {
//        switch (base, compared) {
//            case (.empty, .empty):
//                return true;
//            case (.loading, .loading):
//                return true;
//            case (.error, .error):
//                return true;
//            case (.loaded, .loaded):
//                return true;
//            default:
//                return false;
//        }
//    }
//}

class DateListViewModel: ObservableObject {
    private let service = DateHttpService();
    
    @Published var dates = [CurrentDate]();
    @Published var viewState: ViewState = ViewState.empty;
    
    var message: String {
        switch(self.viewState) {
            case .empty:
                return "No dates yet"
            case .error:
                return "An unexpected error occurred when fetching date"
            default:
                return ""
        }
    }
    
    var hasData: Bool {
        return !dates.isEmpty;
    }
    
    func populateDate() async {
        DispatchQueue.main.async {
            self.viewState = .loading
        }
        do {
            if let date = try await service.getDate() {
                DispatchQueue.main.async {
                    self.dates.append(date)
                    self.viewState = .loaded
                }
            } else {
                DispatchQueue.main.async {
                    self.viewState = .empty
                }            }
        } catch {
            DispatchQueue.main.async {
                self.viewState = .error
            }
        }
    }
    
    func refresh() async {
        DispatchQueue.main.async {
            self.dates = []
        }
        await populateDate();
    }
}

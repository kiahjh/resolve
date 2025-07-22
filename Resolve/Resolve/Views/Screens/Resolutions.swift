import SwiftUI

struct Resolutions: View {
    @Namespace private var namespace
    @State private var searchQuery = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 150, maximum: 400)),
                        GridItem(.flexible(minimum: 150, maximum: 400)),
                    ], spacing: 10
                ) {
                    ForEach(
                        resolutions.filter {
                            self.searchQuery == ""
                                || $0.name.lowercased().contains(self.searchQuery.lowercased())
                        }
                    ) { resolution in
                        NavigationLink {
                            ResolutionDetail(resolution: resolution)
                                .navigationTransition(.zoom(sourceID: resolution.id, in: namespace))
                        } label: {
                            ResolutionCard(resolution: resolution)
                                .matchedTransitionSource(id: resolution.id, in: namespace)
                                .shadow(
                                  color: .black.opacity(0.1), radius: 10, x: 0, y: 4
                                )
                        }
                    }
                }
                .padding()
            }
            .background(Gradient(colors: [.white, .gray.opacity(0.1)]))
            .navigationTitle("Resolutions")
        }
        .searchable(text: $searchQuery, placement: .toolbar)
        .searchToolbarBehavior(.minimize)
    }
}

#Preview {
    Resolutions()
}

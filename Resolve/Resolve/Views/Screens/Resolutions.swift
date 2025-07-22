import SwiftUI

struct Resolutions: View {
  @Namespace private var namespace
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          ForEach(resolutions) { resolution in
            NavigationLink {
              ResolutionDetail(resolution: resolution)
                .navigationTransition(.zoom(sourceID: resolution.id, in: namespace))
            } label: {
              ResolutionCard(name: resolution.name, streakCount: resolution.streakCount)
                .matchedTransitionSource(id: resolution.id, in: namespace)
                .shadow(color: Color("Primary700").opacity(0.25), radius: 10, x: 0, y: 4)
            }
          }
        }
        .padding()
      }
      .background(Gradient(colors: [.white, Color("Primary100")]))
      .navigationTitle("Resolutions")
    }
  }
}

#Preview {
  Resolutions()
}

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      Tab("Resolutions", systemImage: "checklist") {
        Resolutions()
      }
      Tab("Friends", systemImage: "person.2") {
        Text("friends")
      }
    }
  }
}

#Preview {
  ContentView()
}

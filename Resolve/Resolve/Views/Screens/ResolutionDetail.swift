import SwiftUI

struct ResolutionDetail: View {
  let resolution: Resolution
  
  var body: some View {
    Text(resolution.name)
  }
}

#Preview {
  ResolutionDetail(resolution: Resolution(id: "1", name: "Example Resolution", streakCount: 5))
}

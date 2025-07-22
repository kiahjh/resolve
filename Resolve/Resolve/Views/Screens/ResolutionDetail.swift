import SwiftUI

struct ResolutionDetail: View {
  let resolution: Resolution
  
  var body: some View {
    Text(resolution.name)
  }
}

#Preview {
  ResolutionDetail(resolution: resolutions[0])
}

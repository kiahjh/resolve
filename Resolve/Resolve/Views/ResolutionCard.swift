import SwiftUI

struct ResolutionCard: View {
  let name: String
  let streakCount: Int
  
  var body: some View {
    HStack {
      Text(self.name)
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(.black)
      Spacer()
      HStack {
        Text("\(self.streakCount)")
          .font(.system(size: 14, weight: .bold))
          .foregroundStyle(Color(red: 0.98, green: 0.30, blue: 0.20))
        Image("Flame")
          .resizable()
          .frame(width: 16, height: 24)
      }
    }
    .padding(20)
    .background(.white)
    .cornerRadius(16)
  }
}

#Preview {
  VStack {
    ResolutionCard(name: "Example resolution", streakCount: 12)
    ResolutionCard(name: "Another resolution", streakCount: 200)
    ResolutionCard(name: "Another resolution", streakCount: 3202)
    ResolutionCard(name: "Yet another resolution", streakCount: 7)
  }
}

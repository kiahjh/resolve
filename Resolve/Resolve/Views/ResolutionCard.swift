import SwiftUI
import RiveRuntime

// resolution cards have:
// - name ALL ✅
// - current streak ALL ✅
// - penalty
// - ppl it’s shared with ✅
// - duration
// - next check-in ALL

struct ResolutionCard: View {
  let resolution: Resolution
  
  
  var body: some View {
    let flame = streakToFlame(self.resolution.currentStreak)
    VStack {
      HStack {
        Text(self.resolution.name)
          .font(.system(size: 16, weight: .semibold))
          .foregroundStyle(.black)
          .multilineTextAlignment(.leading)
          .shadow(color: .white, radius: 20, x: 0, y: 0)
          .shadow(color: .white, radius: 10, x: 0, y: 0)
          .shadow(color: .white, radius: 5, x: 0, y: 0)
          .shadow(color: .white, radius: 5, x: 0, y: 0)
          .shadow(color: .white, radius: 5, x: 0, y: 0)
        Spacer()
      }
      .padding(6)
      .zIndex(1)
      Spacer()
      RiveViewModel(fileName: "lobster-2").view()
        .frame(height: 105)
      Spacer()
      HStack {
        HStack(spacing: -12) {
          ForEach(self.resolution.sharedWith) { user in
            AsyncImage(url: URL(string: user.imgUrl))
              .frame(width: 24, height: 24)
              .clipShape(Circle())
              .overlay {
                Circle()
                  .stroke(.white, lineWidth: 2)
              }
          }
        }
        Spacer()
        HStack(spacing: 4) {
          if self.resolution.penalty > 0 {
            VStack(alignment: .trailing) {
              Text("Penalty")
                .font(.system(size: 8, weight: .medium))
              Text("$\(self.resolution.penalty)")
                .font(.system(size: 10, weight: .bold))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
          } else {
            VStack(alignment: .center) {
              Text("No")
                .font(.system(size: 8, weight: .medium))
              Text("penalty")
                .font(.system(size: 8, weight: .medium))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
          }
          if self.resolution.until != nil {
            VStack(alignment: .trailing) {
              Text("Ends")
                .font(.system(size: 8, weight: .medium))
              Text(self.resolution.until ?? "")
                .font(.system(size: 10, weight: .bold))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
          } else {
            VStack(alignment: .center) {
              Text("Life-long")
                .font(.system(size: 8, weight: .medium))
              Text("goal")
                .font(.system(size: 8, weight: .medium))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
          }
        }
      }
      .frame(height: 28)
    }
    .padding(8)
    .frame(height: 200)
    .background(.white)
    .cornerRadius(16)
    .foregroundStyle(.black)
  }
}

#Preview {
  ScrollView {
    LazyVGrid(columns: [GridItem(.flexible(minimum: 150, maximum: 400)), GridItem(.flexible(minimum: 150, maximum: 400))], spacing: 10) {
      ForEach(resolutions) { resolution in
        ResolutionCard(resolution: resolution)
          .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
      }
    }
    .padding()
  }
  .background(Gradient(colors: [.white, .gray.opacity(0.1)]))
}

func streakToFlame(_ streak: Int) -> StreakInfo {
  switch streak {
  case 0...7: StreakInfo(img: "Flame1", width: 25, height: 40, yOffset: 5, shadowColor: "#FC4700") // first week (candle)
  case 8...30: StreakInfo(img: "Flame2", width: 38, height: 50, yOffset: 8, shadowColor: "#FC4700") // until end of month (small flame)
  case 31...180: StreakInfo(img: "Flame3", width: 55, height: 100, yOffset: 28, shadowColor: "#FC4700") // until end of 6 months (big flame)
  case 181...730: StreakInfo(img: "Flame4", width: 55, height: 100, yOffset: 28, shadowColor: "#22B0F2") // until end of 2 years (blue flame)
  default: StreakInfo(img: "Flame5", width: 55, height: 100, yOffset: 28, shadowColor: "#510797") // 2+ years (purple flame)
  }
}

struct StreakInfo {
  let img: String
  let width: Int
  let height: Int
  let yOffset: Int
  let shadowColor: String
}

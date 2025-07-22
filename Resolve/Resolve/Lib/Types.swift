import Foundation

typealias Dollars = Int

struct Resolution: Identifiable {
  var id: String
  var name: String
  var currentStreak: Int
  var penalty: Dollars
  var sharedWith: [User]
  var until: String?
  var nextCheckIn: String
}

struct User: Identifiable {
  var id: String
  var username: String
  var imgUrl: String
}

// resolution cards have:
// - name ALL
// - current streak ALL
// - penalty
// - ppl it’s shared with
// - duration
// - next check-in ALL

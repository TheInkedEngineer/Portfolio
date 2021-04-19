import Foundation

extension Date {
  /// Returns the `Date` instance in the `DD-MM-yyyy` format.
  var prettyPrinted: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter.string(from: self)
  }
}

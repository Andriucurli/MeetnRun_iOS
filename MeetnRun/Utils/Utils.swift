//
//  Utils.swift
//  MeetnRun
//
//  Created by ALugo on 24/8/22.
//

import Foundation
import EventKit


 class Utils {
     
     static let Days = [NSLocalizedString("MONDAY", comment: "Monday"),
                        NSLocalizedString("TUESDAY", comment: "Tuesday"),
                        NSLocalizedString("WEDNESDAY", comment: "Wednesday"),
                        NSLocalizedString("THURSDAY", comment: "Thursday"),
                        NSLocalizedString("FRIDAY", comment: "Friday"),
                        NSLocalizedString("SATURDAY", comment: "Saturday"),
                        NSLocalizedString("SUNDAY", comment: "Sunday")]
     
     static public func getDayName(_ day : Int) -> String?{
         return Days[day]
     }
     
     static public func getEKDay(_ day : Int) -> EKWeekday?{
         switch day {
         case 0:
             return .monday
         case 1:
             return .tuesday
         case 2:
             return .wednesday
         case 3:
             return .thursday
         case 4:
             return .friday
         case 5:
             return .saturday
         case 6:
             return .sunday
         default:
             return nil
         }
     }
     
     public static func nextDayOfWeek(dow : Int, hour : Int) -> Date? {
         let calendar = Calendar(identifier: .gregorian)

         // Weekday units are the numbers 1 through n, where n is the number of days in the week.
         // For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
         let weekday = getEKDay(dow)?.rawValue // Sunday
         let sundayComponents = DateComponents(calendar: calendar, hour: hour, weekday: weekday)
          return calendar.nextDate(after: Date(), matching: sundayComponents, matchingPolicy: .nextTimePreservingSmallerComponents)
         }
     
     
     static func setBit(b : UInt8, bit : Int, value : Bool) -> UInt8{
         var result : UInt8!

                 if (value){
                     result = UInt8((b | (1 << bit)))
                 } else {
                     result = UInt8((b & ~(1 << bit)))
                 }

                 return result
     }
     
     static func isBitSet(b : UInt8, bit : Int) -> Bool {
         return (b & (1 << bit)) != 0
     }
     
     enum AppError : Error {
         case AppDelegateNotFound
     }
}

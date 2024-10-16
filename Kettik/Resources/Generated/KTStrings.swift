
import Foundation


// MARK: - Strings

public enum KTStrings {

  public enum Auth {
    /// Confirmation code
    public static let confirmationCode = KTStrings.tr("Localizable", "auth.confirmation_code")
    /// Please enter the code we emailed you.
    public static let confirmationText = KTStrings.tr("Localizable", "auth.confirmation_text")
    /// We just emailed you.
    public static let confirmationTitle = KTStrings.tr("Localizable", "auth.confirmation_title")
    /// Enter your full name
    public static let enterFullName = KTStrings.tr("Localizable", "auth.enter_full_name")
    /// Enter password
    public static let enterPassword = KTStrings.tr("Localizable", "auth.enter_password")
    /// Enter your email
    public static let enterYourEmail = KTStrings.tr("Localizable", "auth.enter_your_email")
    /// Enter your password
    public static let enterYourPassword = KTStrings.tr("Localizable", "auth.enter_your_password")
    /// Forgot Password?
    public static let fogotPassword = KTStrings.tr("Localizable", "auth.fogot_password")
    /// Log In
    public static let logIn = KTStrings.tr("Localizable", "auth.log_in")
    /// Your password must include at least one symbol and be 8 or more character
    public static let passwordHint = KTStrings.tr("Localizable", "auth.password_hint")
    /// Resend Code
    public static let resendCode = KTStrings.tr("Localizable", "auth.resend_code")
    /// Sign Up
    public static let signUp = KTStrings.tr("Localizable", "auth.sign_up")
    /// Don't have an account?
    public static let signUpText = KTStrings.tr("Localizable", "auth.sign_up_text")
    /// Welcome back!
    public static let title = KTStrings.tr("Localizable", "auth.title")
    /// Verify
    public static let verify = KTStrings.tr("Localizable", "auth.verify")
  }

  public enum Common {
    /// Email
    public static let email = KTStrings.tr("Localizable", "common.email")
    /// Full Name
    public static let fullName = KTStrings.tr("Localizable", "common.full_name")
    /// Password
    public static let password = KTStrings.tr("Localizable", "common.password")
    /// Sign Up
    public static let signUp = KTStrings.tr("Localizable", "common.sign_up")
    /// View all
    public static let viewAll = KTStrings.tr("Localizable", "common.view_all")
  }

  public enum Explore {
    /// Welcome to Almaty!
    public static let title = KTStrings.tr("Localizable", "explore.title")
    /// search text
    public static let searchText = KTStrings.tr("Localizable", "explore.searchText")
  }

  public enum Profile {
    /// Question & Answers
    public static let faq = KTStrings.tr("Localizable", "profile.faq")
    /// Favourites
    public static let favourites = KTStrings.tr("Localizable", "profile.favourites")
    /// Language
    public static let language = KTStrings.tr("Localizable", "profile.language")
    /// My Profile
    public static let myProfile = KTStrings.tr("Localizable", "profile.my_profile")
    /// My Tickets
    public static let myTickets = KTStrings.tr("Localizable", "profile.my_tickets")
    /// Sign Out
    public static let signOut = KTStrings.tr("Localizable", "profile.sign_out")
    /// We are in social media :)
    public static let socialMediaTitle = KTStrings.tr("Localizable", "profile.social_media_title")
    /// Save
    public static let save = KTStrings.tr("Localizable", "profile.save")

  }

  public enum Tab {
    /// Community
    public static let orders = KTStrings.tr("Localizable", "tab.orders")
    /// Explore
    public static let explore = KTStrings.tr("Localizable", "tab.explore")
    /// Guides
    public static let guides = KTStrings.tr("Localizable", "tab.guides")
    /// Profile
    public static let profile = KTStrings.tr("Localizable", "tab.profile")
  }

  public enum Trip {
    /// About tour
    public static let aboutTour = KTStrings.tr("Localizable", "trip.about_tour")
    /// Book now
    public static let bookNow = KTStrings.tr("Localizable", "trip.book_now")
    /// / person
    public static let slashPerson = KTStrings.tr("Localizable", "trip.slash_person")
    /// Total Price
    public static let totalPrice = KTStrings.tr("Localizable", "trip.total_price")
      
    public enum Difficulty {
      /// Easy
      public static let easy = KTStrings.tr("Localizable", "trip.difficulty.easy")
      /// Hard
      public static let hard = KTStrings.tr("Localizable", "trip.difficulty.hard")
      /// Medium
      public static let medium = KTStrings.tr("Localizable", "trip.difficulty.medium")
    }
  }
    
    public enum Ticket {
    /// date
    public static let date = KTStrings.tr("Localizable", "ticket.date")
    /// count
    public static let count = KTStrings.tr("Localizable", "ticket.count")
    /// price
    public static let price = KTStrings.tr("Localizable", "ticket.price")
    /// trip
    public static let trip = KTStrings.tr("Localizable", "ticket.trip")
    /// ticket
    public static let ticket = KTStrings.tr("Localizable", "ticket.ticket")
    /// Make purchase
    public static let makePurchase = KTStrings.tr("Localizable", "ticket.make_purchase")
    /// Purchased
    public static let purchased = KTStrings.tr("Localizable", "ticket.purchased")
    /// Pending
    public static let pending = KTStrings.tr("Localizable", "ticket.pending")
    /// status
    public static let status = KTStrings.tr("Localizable", "ticket.status")
    /// invalid
    public static let invalid = KTStrings.tr("Localizable", "ticket.invalid")


    }
}

// MARK: - Implementation Details

extension KTStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}

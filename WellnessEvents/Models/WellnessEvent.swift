import SwiftUI

enum EventCategory: String, CaseIterable, Codable, Identifiable, Hashable {
    case yoga = "Yoga"
    case meditation = "Meditation"
    case soundBath = "Sound Bath"
    case retreat = "Retreat"
    case workshop = "Workshop"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .yoga: return "figure.yoga"
        case .meditation: return "brain.head.profile"
        case .soundBath: return "waveform"
        case .retreat: return "leaf.fill"
        case .workshop: return "person.2.fill"
        case .other: return "star.fill"
        }
    }

    var badgeColor: Color {
        switch self {
        case .yoga: return .appMint
        case .meditation: return .appLavender
        case .soundBath: return .appBlue
        case .retreat: return .appMint
        case .workshop: return .appLavender
        case .other: return .appGray
        }
    }

    var badgeTextColor: Color {
        switch self {
        case .soundBath: return Color(hex: "1A5276")
        default: return Color(hex: "1E5631")
        }
    }
}

struct ScheduleItem: Identifiable, Codable, Hashable {
    var id: String
    var time: String
    var activity: String

    init(id: String = UUID().uuidString, time: String, activity: String) {
        self.id = id
        self.time = time
        self.activity = activity
    }
}

struct WellnessEvent: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String
    var category: EventCategory
    var date: Date
    var location: String
    var latitude: Double
    var longitude: Double
    var maxCapacity: Int
    var ticketPrice: Double
    var organizerId: String
    var organizerName: String
    var organizerBio: String
    var imageName: String
    var schedule: [ScheduleItem]
    var attendeeCount: Int

    var revenue: Double { Double(attendeeCount) * ticketPrice }
    var isSoldOut: Bool { attendeeCount >= maxCapacity }
    var availableSpots: Int { max(0, maxCapacity - attendeeCount) }
    var formattedPrice: String {
        ticketPrice == 0 ? "Free" : String(format: "$%.0f", ticketPrice)
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: EventCategory,
        date: Date,
        location: String,
        latitude: Double = 0,
        longitude: Double = 0,
        maxCapacity: Int,
        ticketPrice: Double,
        organizerId: String,
        organizerName: String,
        organizerBio: String,
        imageName: String,
        schedule: [ScheduleItem] = [],
        attendeeCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.date = date
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.maxCapacity = maxCapacity
        self.ticketPrice = ticketPrice
        self.organizerId = organizerId
        self.organizerName = organizerName
        self.organizerBio = organizerBio
        self.imageName = imageName
        self.schedule = schedule
        self.attendeeCount = attendeeCount
    }
}

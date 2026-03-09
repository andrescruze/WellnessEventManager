import Foundation

struct MockData {

    // MARK: - Mock Users

    static let organizer1 = User(
        id: "org1",
        name: "Maya Patel",
        email: "maya@zenflow.com",
        password: "password123",
        role: .organizer,
        bio: "Certified yoga instructor with 15 years of experience. Founder of ZenFlow Wellness. Trained in Mysore, Bali, and Rishikesh."
    )

    static let organizer2 = User(
        id: "org2",
        name: "Kai Nakamura",
        email: "kai@soundhealing.com",
        password: "password123",
        role: .organizer,
        bio: "Sound healer and meditation guide. Trained in ancient Tibetan and modern sound therapy techniques across Bali, Tulum, and Sedona."
    )

    static let attendee1 = User(
        id: "att1",
        name: "Sofia Rivera",
        email: "sofia@email.com",
        password: "password123",
        role: .attendee,
        bio: "Wellness enthusiast exploring the world one retreat at a time."
    )

    // MARK: - Mock Attendee Names (for organizer views)

    static let attendeeNames = [
        "Emma Johnson", "Liam Chen", "Sofia Rodriguez", "Noah Williams",
        "Olivia Martinez", "Ethan Park", "Ava Thompson", "Lucas Brown",
        "Isabella Garcia", "Mason Lee", "Mia White", "Aiden Davis",
        "Charlotte Wilson", "James Taylor", "Amelia Anderson", "Benjamin Harris",
        "Harper Jackson", "Oliver Thomas", "Evelyn Moore", "Daniel Martin",
        "Abigail Jackson", "Henry Lewis", "Emily Clark", "Michael Robinson",
        "Elizabeth Walker", "Daniel Hall", "Sofía Hernandez", "Matthew Young"
    ]

    // MARK: - Sample Events

    static var sampleEvents: [WellnessEvent] = [
        WellnessEvent(
            id: "evt1",
            title: "Sunrise Yoga Retreat in Bali",
            description: "Immerse yourself in a transformative 5-day yoga retreat nestled in the lush rice terraces of Ubud, Bali. Begin each morning with sunrise flow, deepen your practice with afternoon workshops, and restore with evening meditation by candlelight.\n\nAll levels welcome. Accommodation, organic meals, and airport transfers included. This retreat is limited to 20 participants for an intimate experience that prioritizes depth over breadth.",
            category: .retreat,
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            location: "Ubud, Bali, Indonesia",
            latitude: -8.5069,
            longitude: 115.2625,
            maxCapacity: 20,
            ticketPrice: 1200.00,
            organizerId: "org1",
            organizerName: "Maya Patel",
            organizerBio: "Certified yoga instructor with 15 years of experience. Founder of ZenFlow Wellness. Trained in Mysore, Bali, and Rishikesh.",
            imageName: "figure.yoga",
            schedule: [
                ScheduleItem(time: "6:00 AM", activity: "Sunrise Flow Yoga"),
                ScheduleItem(time: "8:00 AM", activity: "Nourishing Breakfast"),
                ScheduleItem(time: "10:00 AM", activity: "Yoga Philosophy Workshop"),
                ScheduleItem(time: "1:00 PM", activity: "Mindful Lunch"),
                ScheduleItem(time: "3:00 PM", activity: "Afternoon Restorative Practice"),
                ScheduleItem(time: "7:00 PM", activity: "Candlelit Meditation")
            ],
            attendeeCount: 14
        ),
        WellnessEvent(
            id: "evt2",
            title: "Crystal Sound Bath Journey",
            description: "Journey into deep relaxation through the healing vibrations of crystal singing bowls, Tibetan bowls, and gongs. This immersive sound healing session dissolves stress and realigns your energy centers.\n\nCome as you are — no experience needed. Simply lie back and let the frequencies do the work. Blankets and eye masks provided. Space is limited.",
            category: .soundBath,
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            location: "Tulum, Quintana Roo, Mexico",
            latitude: 20.2114,
            longitude: -87.4654,
            maxCapacity: 30,
            ticketPrice: 85.00,
            organizerId: "org2",
            organizerName: "Kai Nakamura",
            organizerBio: "Sound healer and meditation guide. Trained in ancient Tibetan and modern sound therapy techniques across Bali, Tulum, and Sedona.",
            imageName: "waveform",
            schedule: [
                ScheduleItem(time: "6:00 PM", activity: "Arrival & Grounding"),
                ScheduleItem(time: "6:30 PM", activity: "Breathwork Introduction"),
                ScheduleItem(time: "7:00 PM", activity: "Crystal Bowl Journey"),
                ScheduleItem(time: "8:30 PM", activity: "Integration & Tea Ceremony")
            ],
            attendeeCount: 22
        ),
        WellnessEvent(
            id: "evt3",
            title: "Mindfulness Meditation Workshop",
            description: "Learn the foundational practices of mindfulness meditation in this half-day workshop. Discover how to cultivate present-moment awareness, work with difficult emotions, and establish a sustainable daily practice.\n\nIncludes guided meditations, Q&A session, and take-home resources. Suitable for complete beginners and those refreshing their practice.",
            category: .meditation,
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            location: "Los Angeles, CA",
            latitude: 34.0522,
            longitude: -118.2437,
            maxCapacity: 25,
            ticketPrice: 65.00,
            organizerId: "org1",
            organizerName: "Maya Patel",
            organizerBio: "Certified yoga instructor with 15 years of experience. Founder of ZenFlow Wellness. Trained in Mysore, Bali, and Rishikesh.",
            imageName: "brain.head.profile",
            schedule: [
                ScheduleItem(time: "9:00 AM", activity: "Welcome & Introduction"),
                ScheduleItem(time: "9:30 AM", activity: "Body Scan Meditation"),
                ScheduleItem(time: "10:30 AM", activity: "Mindfulness in Daily Life"),
                ScheduleItem(time: "11:30 AM", activity: "Loving-Kindness Practice"),
                ScheduleItem(time: "12:30 PM", activity: "Q&A & Closing Circle")
            ],
            attendeeCount: 18
        ),
        WellnessEvent(
            id: "evt4",
            title: "Vinyasa Flow Yoga Class",
            description: "A dynamic, breath-led yoga practice that links movement with breath. Build strength, flexibility, and focus through flowing sequences designed to energize the body and calm the mind.\n\nPerfect for those with some yoga experience looking to deepen their practice. Mats provided. Wear comfortable, stretchy clothing.",
            category: .yoga,
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            location: "Brooklyn, New York",
            latitude: 40.6782,
            longitude: -73.9442,
            maxCapacity: 15,
            ticketPrice: 25.00,
            organizerId: "org1",
            organizerName: "Maya Patel",
            organizerBio: "Certified yoga instructor with 15 years of experience. Founder of ZenFlow Wellness. Trained in Mysore, Bali, and Rishikesh.",
            imageName: "figure.yoga",
            schedule: [
                ScheduleItem(time: "7:00 AM", activity: "Pranayama & Warm-Up"),
                ScheduleItem(time: "7:20 AM", activity: "Vinyasa Flow Sequence"),
                ScheduleItem(time: "8:20 AM", activity: "Savasana & Closing")
            ],
            attendeeCount: 12
        ),
        WellnessEvent(
            id: "evt5",
            title: "Breathwork & Nervous System Reset",
            description: "Experience the transformative power of conscious breathing. This workshop teaches Holotropic and Wim Hof-inspired techniques to activate your body's natural healing response, reduce anxiety, and boost energy.\n\nLeave feeling clear, calm, and deeply restored. No experience necessary. Please avoid eating 2 hours before the session.",
            category: .workshop,
            date: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
            location: "Austin, Texas",
            latitude: 30.2672,
            longitude: -97.7431,
            maxCapacity: 20,
            ticketPrice: 95.00,
            organizerId: "org2",
            organizerName: "Kai Nakamura",
            organizerBio: "Sound healer and meditation guide. Trained in ancient Tibetan and modern sound therapy techniques across Bali, Tulum, and Sedona.",
            imageName: "wind",
            schedule: [
                ScheduleItem(time: "10:00 AM", activity: "Nervous System Education"),
                ScheduleItem(time: "11:00 AM", activity: "Guided Breathwork Session"),
                ScheduleItem(time: "12:30 PM", activity: "Integration Practice"),
                ScheduleItem(time: "1:00 PM", activity: "Group Sharing & Close")
            ],
            attendeeCount: 8
        ),
        WellnessEvent(
            id: "evt6",
            title: "Jungle Wellness Retreat Tulum",
            description: "A luxurious 3-day wellness immersion in an eco-chic jungle setting. Featuring daily yoga, cacao ceremonies, cenote swimming, sound healing, and organic farm-to-table meals.\n\nLimited to 12 participants for an intimate, personalized experience. Accommodation in open-air jungle bungalows included. Transportation from Tulum town provided.",
            category: .retreat,
            date: Calendar.current.date(byAdding: .day, value: 21, to: Date())!,
            location: "Tulum, Quintana Roo, Mexico",
            latitude: 20.2114,
            longitude: -87.4654,
            maxCapacity: 12,
            ticketPrice: 850.00,
            organizerId: "org2",
            organizerName: "Kai Nakamura",
            organizerBio: "Sound healer and meditation guide. Trained in ancient Tibetan and modern sound therapy techniques across Bali, Tulum, and Sedona.",
            imageName: "leaf.fill",
            schedule: [
                ScheduleItem(time: "Day 1", activity: "Arrival, Welcome Ceremony & Cacao"),
                ScheduleItem(time: "Day 2", activity: "Morning Yoga, Cenote Swim, Sound Bath"),
                ScheduleItem(time: "Day 3", activity: "Integration Yoga, Closing Ceremony")
            ],
            attendeeCount: 7
        ),
        WellnessEvent(
            id: "evt7",
            title: "Yin Yoga & Restorative Evening",
            description: "Slow down, release, and restore with this deeply nourishing yin yoga class. Hold poses for 3–5 minutes to target deep connective tissues, improve flexibility, and calm the nervous system.\n\nProps (bolsters, blocks, blankets) provided. Perfect for all levels, especially those who feel tight, stressed, or overworked.",
            category: .yoga,
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            location: "San Francisco, CA",
            latitude: 37.7749,
            longitude: -122.4194,
            maxCapacity: 20,
            ticketPrice: 30.00,
            organizerId: "org1",
            organizerName: "Maya Patel",
            organizerBio: "Certified yoga instructor with 15 years of experience. Founder of ZenFlow Wellness. Trained in Mysore, Bali, and Rishikesh.",
            imageName: "figure.mind.and.body",
            schedule: [
                ScheduleItem(time: "6:30 PM", activity: "Centering & Intention Setting"),
                ScheduleItem(time: "6:45 PM", activity: "Yin Yoga Sequence"),
                ScheduleItem(time: "8:00 PM", activity: "Yoga Nidra"),
                ScheduleItem(time: "8:30 PM", activity: "Herbal Tea & Community")
            ],
            attendeeCount: 11
        ),
        WellnessEvent(
            id: "evt8",
            title: "Planetary Gong Bath Ceremony",
            description: "Journey into the cosmic soundscape of planetary gongs. The resonant frequencies of these ancient instruments induce deep theta-state relaxation, releasing tension held in the body and mind.\n\nBlankets and eye masks provided. Arrive 15 minutes early to settle in. This experience is suitable for most people but consult your doctor if you are pregnant or have a pacemaker.",
            category: .soundBath,
            date: Calendar.current.date(byAdding: .day, value: 8, to: Date())!,
            location: "Miami, Florida",
            latitude: 25.7617,
            longitude: -80.1918,
            maxCapacity: 25,
            ticketPrice: 55.00,
            organizerId: "org2",
            organizerName: "Kai Nakamura",
            organizerBio: "Sound healer and meditation guide. Trained in ancient Tibetan and modern sound therapy techniques across Bali, Tulum, and Sedona.",
            imageName: "waveform.badge.magnifyingglass",
            schedule: [
                ScheduleItem(time: "7:30 PM", activity: "Arrival & Settling In"),
                ScheduleItem(time: "8:00 PM", activity: "Planetary Gong Bath"),
                ScheduleItem(time: "9:30 PM", activity: "Silent Integration")
            ],
            attendeeCount: 19
        )
    ]
}

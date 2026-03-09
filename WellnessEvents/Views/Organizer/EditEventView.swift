import SwiftUI

struct EditEventView: View {
    let event: WellnessEvent
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var description: String
    @State private var category: EventCategory
    @State private var date: Date
    @State private var location: String
    @State private var maxCapacity: Int
    @State private var ticketPrice: Double
    @State private var selectedImageName: String
    @State private var scheduleItems: [ScheduleItem]

    let sfSymbolOptions = [
        "figure.yoga", "brain.head.profile", "waveform", "leaf.fill",
        "person.2.fill", "wind", "heart.fill", "star.fill",
        "figure.mind.and.body", "sparkles", "sun.max.fill", "moon.fill"
    ]

    init(event: WellnessEvent) {
        self.event = event
        _title = State(initialValue: event.title)
        _description = State(initialValue: event.description)
        _category = State(initialValue: event.category)
        _date = State(initialValue: event.date)
        _location = State(initialValue: event.location)
        _maxCapacity = State(initialValue: event.maxCapacity)
        _ticketPrice = State(initialValue: event.ticketPrice)
        _selectedImageName = State(initialValue: event.imageName)
        _scheduleItems = State(initialValue: event.schedule.isEmpty
            ? [ScheduleItem(time: "", activity: "")]
            : event.schedule
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                Form {
                    Section {
                        FormTextField(label: "Event Title", placeholder: "Event title", text: $title)
                        FormTextEditor(label: "Description", text: $description)
                    } header: { SectionLabel(text: "Basic Information") }
                    .listRowBackground(Color.white)

                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            Picker("Category", selection: $category) {
                                ForEach(EventCategory.allCases) { cat in
                                    Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.appBlue)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cover Icon")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                                ForEach(sfSymbolOptions, id: \.self) { symbol in
                                    Button {
                                        selectedImageName = symbol
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedImageName == symbol ? Color.appMint : Color.appGray.opacity(0.2))
                                                .frame(height: 44)
                                            Image(systemName: symbol)
                                                .font(.title3)
                                                .foregroundStyle(selectedImageName == symbol ? Color(hex: "1E5631") : .secondary)
                                        }
                                    }
                                }
                            }
                        }
                    } header: { SectionLabel(text: "Event Style") }
                    .listRowBackground(Color.white)

                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date & Time")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.appBlue)
                        }
                        FormTextField(label: "Location", placeholder: "City, Country", text: $location)
                    } header: { SectionLabel(text: "When & Where") }
                    .listRowBackground(Color.white)

                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Max Capacity")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                Spacer()
                                Text("\(maxCapacity) people")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appDarkText)
                            }
                            Slider(value: Binding(
                                get: { Double(maxCapacity) },
                                set: { maxCapacity = Int($0) }
                            ), in: Double(event.attendeeCount)...200, step: 5)
                            .tint(Color.appMint)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ticket Price")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                Spacer()
                                Text(ticketPrice == 0 ? "Free" : String(format: "$%.0f", ticketPrice))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.appMint)
                            }
                            Slider(value: $ticketPrice, in: 0...2000, step: 5)
                                .tint(Color.appMint)
                        }
                    } header: { SectionLabel(text: "Capacity & Pricing") }
                    .listRowBackground(Color.white)

                    Section {
                        ForEach($scheduleItems) { $item in
                            HStack(spacing: 10) {
                                TextField("Time", text: $item.time)
                                    .frame(width: 80)
                                    .padding(8)
                                    .background(Color.appLavender.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                TextField("Activity", text: $item.activity)
                                    .padding(8)
                                    .background(Color.appLavender.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .onDelete { scheduleItems.remove(atOffsets: $0) }

                        Button {
                            scheduleItems.append(ScheduleItem(time: "", activity: ""))
                        } label: {
                            Label("Add Item", systemImage: "plus.circle")
                                .foregroundStyle(Color.appBlue)
                        }
                    } header: { SectionLabel(text: "Schedule") }
                    .listRowBackground(Color.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.appBlue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(title.isEmpty ? Color.secondary : Color.appMint)
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        var updated = event
        updated.title = title
        updated.description = description
        updated.category = category
        updated.date = date
        updated.location = location
        updated.maxCapacity = maxCapacity
        updated.ticketPrice = ticketPrice
        updated.imageName = selectedImageName
        updated.schedule = scheduleItems.filter { !$0.activity.isEmpty }
        eventsViewModel.updateEvent(updated)
        dismiss()
    }
}

#Preview {
    EditEventView(event: MockData.sampleEvents[0])
        .environment(AuthViewModel())
        .environment(EventsViewModel())
}

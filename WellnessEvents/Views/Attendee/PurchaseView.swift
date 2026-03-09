import SwiftUI

private enum PurchaseStep {
    case selection, payment, confirmation
}

struct PurchaseView: View {
    let event: WellnessEvent
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(TicketsViewModel.self) private var ticketsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var step: PurchaseStep = .selection
    @State private var ticketCount: Int = 1
    @State private var purchasedTicket: Ticket?

    // Payment fields
    @State private var cardName = ""
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var isProcessing = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                switch step {
                case .selection:
                    TicketSelectionView(
                        event: event,
                        ticketCount: $ticketCount,
                        onContinue: { step = .payment }
                    )
                case .payment:
                    PaymentFormView(
                        event: event,
                        ticketCount: ticketCount,
                        cardName: $cardName,
                        cardNumber: $cardNumber,
                        expiry: $expiry,
                        cvv: $cvv,
                        isProcessing: $isProcessing,
                        onBack: { step = .selection },
                        onPay: completePayment
                    )
                case .confirmation:
                    if let ticket = purchasedTicket {
                        ConfirmationView(ticket: ticket, onDone: { dismiss() })
                    }
                }
            }
            .navigationTitle(stepTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if step == .selection {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                            .foregroundStyle(Color.appBlue)
                    }
                }
            }
        }
    }

    private var stepTitle: String {
        switch step {
        case .selection: return "Select Tickets"
        case .payment: return "Payment"
        case .confirmation: return "Booking Confirmed"
        }
    }

    private func completePayment() {
        guard let user = authViewModel.currentUser else { return }
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let ticket = ticketsViewModel.purchaseTicket(
                event: event,
                userId: user.id,
                count: ticketCount
            )
            eventsViewModel.incrementAttendee(eventId: event.id, by: ticketCount)
            purchasedTicket = ticket
            isProcessing = false
            withAnimation { step = .confirmation }
        }
    }
}

// MARK: - Step 1: Ticket Selection

private struct TicketSelectionView: View {
    let event: WellnessEvent
    @Binding var ticketCount: Int
    let onContinue: () -> Void

    var total: Double { Double(ticketCount) * event.ticketPrice }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // Event summary card
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.appMint.opacity(0.3))
                                .frame(width: 60, height: 60)
                            Image(systemName: event.imageName)
                                .font(.title2)
                                .foregroundStyle(Color(hex: "1E5631"))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.headline)
                                .foregroundStyle(Color.appDarkText)
                                .lineLimit(2)
                            HStack(spacing: 8) {
                                Label(event.date.formatted(.dateTime.month().day()), systemImage: "calendar")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Label(event.location.components(separatedBy: ",").first ?? "", systemImage: "mappin")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.05), radius: 6)

                    // Ticket counter
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Number of Tickets")
                            .font(.headline)
                            .foregroundStyle(Color.appBlue)

                        HStack {
                            Text("General Admission")
                                .font(.subheadline)
                                .foregroundStyle(Color.appDarkText)
                            Spacer()
                            HStack(spacing: 16) {
                                Button {
                                    if ticketCount > 1 { ticketCount -= 1 }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(ticketCount > 1 ? Color.appBlue : Color.appGray)
                                }
                                Text("\(ticketCount)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.appDarkText)
                                    .frame(minWidth: 28)
                                Button {
                                    if ticketCount < min(event.availableSpots, 10) { ticketCount += 1 }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(ticketCount < min(event.availableSpots, 10) ? Color.appBlue : Color.appGray)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        HStack {
                            Text("\(event.availableSpots) spots available")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(event.formattedPrice) per ticket")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Price breakdown
                    VStack(spacing: 12) {
                        PriceRow(label: "\(ticketCount) × ticket", value: String(format: "$%.2f", total))
                        Divider()
                        PriceRow(label: "Service fee", value: "Free")
                        Divider()
                        PriceRow(label: "Total", value: String(format: "$%.2f", total), isBold: true)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            // Bottom bar
            VStack(spacing: 0) {
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "$%.2f", total))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.appDarkText)
                    }
                    Spacer()
                    Button(action: onContinue) {
                        Text("Continue to Payment")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(hex: "1E5631"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.appMint)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.appBeige)
            }
        }
    }
}

// MARK: - Step 2: Payment Form

private struct PaymentFormView: View {
    let event: WellnessEvent
    let ticketCount: Int
    @Binding var cardName: String
    @Binding var cardNumber: String
    @Binding var expiry: String
    @Binding var cvv: String
    @Binding var isProcessing: Bool
    let onBack: () -> Void
    let onPay: () -> Void

    var total: Double { Double(ticketCount) * event.ticketPrice }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress
                    StepIndicator(currentStep: 2)

                    // Mock payment notice
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .foregroundStyle(Color.appMint)
                        Text("This is a mock payment — no real charges will be made.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(Color.appMint.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    // Card form
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Card Details")
                            .font(.headline)
                            .foregroundStyle(Color.appBlue)

                        PaymentField(label: "Name on Card", placeholder: "John Smith", text: $cardName, keyboardType: .default)
                        PaymentField(label: "Card Number", placeholder: "4242 4242 4242 4242", text: $cardNumber, keyboardType: .numberPad)

                        HStack(spacing: 12) {
                            PaymentField(label: "Expiry", placeholder: "MM/YY", text: $expiry, keyboardType: .numberPad)
                            PaymentField(label: "CVV", placeholder: "123", text: $cvv, keyboardType: .numberPad)
                        }
                    }

                    // Order summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Order Summary")
                            .font(.headline)
                            .foregroundStyle(Color.appBlue)
                        PriceRow(label: "\(ticketCount) × \(event.title)", value: String(format: "$%.2f", total))
                        Divider()
                        PriceRow(label: "Total charged", value: String(format: "$%.2f", total), isBold: true)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.appBlue)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    Button {
                        if !isProcessing { onPay() }
                    } label: {
                        HStack {
                            if isProcessing {
                                ProgressView().tint(.white)
                            } else {
                                Image(systemName: "lock.fill")
                                Text("Pay \(String(format: "$%.2f", total))")
                            }
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "1E5631"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.appMint)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isProcessing)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.appBeige)
            }
        }
    }
}

// MARK: - Step 3: Confirmation

private struct ConfirmationView: View {
    let ticket: Ticket
    let onDone: () -> Void
    @State private var showCheckmark = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Success animation
            ZStack {
                Circle()
                    .fill(Color.appMint.opacity(0.2))
                    .frame(width: 120, height: 120)
                Circle()
                    .fill(Color.appMint)
                    .frame(width: 90, height: 90)
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .scaleEffect(showCheckmark ? 1 : 0.3)
                    .opacity(showCheckmark ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring(duration: 0.5, bounce: 0.5)) {
                    showCheckmark = true
                }
            }

            VStack(spacing: 8) {
                Text("You're all set!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appDarkText)
                Text("Your ticket for \(ticket.eventTitle) has been confirmed. Check your tickets tab to view your QR code.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            // Ticket preview card
            VStack(spacing: 14) {
                QRCodeView(data: ticket.qrCodeData, size: 160)
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appMint, lineWidth: 2)
                    )

                Text("Ticket #\(String(ticket.id.prefix(8)).uppercased())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fontDesign(.monospaced)
            }

            Spacer()

            Button(action: onDone) {
                Text("View My Tickets")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(hex: "1E5631"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appMint)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.appMint.opacity(0.4), radius: 6, y: 3)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.appBeige.ignoresSafeArea())
    }
}

// MARK: - Supporting Views

private struct PriceRow: View {
    let label: String
    let value: String
    var isBold: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .headline : .subheadline)
                .foregroundStyle(isBold ? Color.appDarkText : .secondary)
            Spacer()
            Text(value)
                .font(isBold ? .headline : .subheadline)
                .fontWeight(isBold ? .bold : .regular)
                .foregroundStyle(isBold ? Color.appDarkText : .secondary)
        }
    }
}

private struct PaymentField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appBlue)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appLavender, lineWidth: 1.5)
                )
        }
    }
}

private struct StepIndicator: View {
    let currentStep: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.appMint : Color.appGray)
                    .frame(width: 10, height: 10)
                if step < 3 {
                    Rectangle()
                        .fill(step < currentStep ? Color.appMint : Color.appGray)
                        .frame(height: 2)
                }
            }
        }
        .padding(.horizontal, 60)
    }
}

#Preview {
    PurchaseView(event: MockData.sampleEvents[0])
        .environment(AuthViewModel())
        .environment(EventsViewModel())
        .environment(TicketsViewModel())
}

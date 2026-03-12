import SwiftUI

struct MockPaymentSheetView: View {
    let community: Community
    let tier: Tier
    let onSuccess: () -> Void

    @State private var viewModel: PaymentViewModel
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvc = ""
    @Environment(\.dismiss) private var dismiss

    init(community: Community, tier: Tier, onSuccess: @escaping () -> Void) {
        self.community = community
        self.tier = tier
        self.onSuccess = onSuccess
        self._viewModel = State(initialValue: PaymentViewModel(community: community, tier: tier))
    }

    // MARK: - Card helpers

    private var formattedPrice: String {
        let decimal = NSDecimalNumber(decimal: tier.monthlyPrice)
        let value = decimal.doubleValue
        if value == Double(Int(value)) {
            return "$\(Int(value)).00"
        } else {
            return String(format: "$%.2f", value)
        }
    }

    private var cardBrand: (icon: String, name: String)? {
        let digits = cardNumber.filter(\.isNumber)
        guard let first = digits.first else { return nil }
        switch first {
        case "4": return ("creditcard.fill", "Visa")
        case "5": return ("creditcard.fill", "Mastercard")
        case "3": return ("creditcard.fill", "Amex")
        default: return nil
        }
    }

    private func formatCardNumber(_ input: String) -> String {
        let digits = String(input.filter(\.isNumber).prefix(16))
        var result = ""
        for (index, char) in digits.enumerated() {
            if index > 0 && index % 4 == 0 { result += " " }
            result.append(char)
        }
        return result
    }

    private func formatExpiry(_ input: String) -> String {
        let digits = String(input.filter(\.isNumber).prefix(4))
        if digits.count > 2 {
            return String(digits.prefix(2)) + "/" + String(digits.dropFirst(2))
        }
        return String(digits)
    }

    private func formatCVC(_ input: String) -> String {
        String(input.filter(\.isNumber).prefix(4))
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            HStack {
                Text("Payment")
                    .font(BlossomFont.title)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    if !viewModel.isProcessing {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(width: 28, height: 28)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(viewModel.isProcessing)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - Tier Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text(tier.name)
                            .font(BlossomFont.headline)
                            .foregroundStyle(.white)
                        Text("\(formattedPrice)/mo")
                            .font(BlossomFont.title)
                            .foregroundStyle(.white)

                        if !tier.benefits.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(tier.benefits.prefix(3), id: \.self) { benefit in
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(Color(red: 0.4, green: 0.85, blue: 0.65))
                                        Text(benefit)
                                            .font(BlossomFont.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                            .lineLimit(1)
                                    }
                                }
                                if tier.benefits.count > 3 {
                                    Text("+\(tier.benefits.count - 3) more benefits")
                                        .font(BlossomFont.caption)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    // MARK: - Card Fields
                    VStack(spacing: 12) {
                        // Card number
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Card number")
                                .font(BlossomFont.caption)
                                .foregroundStyle(.white.opacity(0.6))
                            HStack(spacing: 8) {
                                TextField("1234 5678 9012 3456", text: $cardNumber)
                                    .keyboardType(.numberPad)
                                    .foregroundStyle(.white)
                                    .font(BlossomFont.body)
                                    .onChange(of: cardNumber) { _, newValue in
                                        cardNumber = formatCardNumber(newValue)
                                    }

                                if let brand = cardBrand {
                                    HStack(spacing: 4) {
                                        Image(systemName: brand.icon)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white.opacity(0.8))
                                        Text(brand.name)
                                            .font(BlossomFont.caption)
                                            .foregroundStyle(.white.opacity(0.6))
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(red: 0.102, green: 0.122, blue: 0.212))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }

                        // Expiry + CVC row
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Expiry")
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(.white.opacity(0.6))
                                TextField("MM/YY", text: $expiry)
                                    .keyboardType(.numberPad)
                                    .foregroundStyle(.white)
                                    .font(BlossomFont.body)
                                    .onChange(of: expiry) { _, newValue in
                                        expiry = formatExpiry(newValue)
                                    }
                                    .padding(12)
                                    .background(Color(red: 0.102, green: 0.122, blue: 0.212))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("CVC")
                                    .font(BlossomFont.caption)
                                    .foregroundStyle(.white.opacity(0.6))
                                TextField("123", text: $cvc)
                                    .keyboardType(.numberPad)
                                    .foregroundStyle(.white)
                                    .font(BlossomFont.body)
                                    .onChange(of: cvc) { _, newValue in
                                        cvc = formatCVC(newValue)
                                    }
                                    .padding(12)
                                    .background(Color(red: 0.102, green: 0.122, blue: 0.212))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // MARK: - Pay Button
                    Button {
                        if viewModel.state == .idle {
                            Task { await viewModel.submitPayment() }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isProcessing {
                                ProgressView()
                                    .tint(.white)
                                Text("Processing...")
                                    .font(BlossomFont.headline)
                                    .foregroundStyle(.white)
                            } else {
                                Text("Pay \(formattedPrice)")
                                    .font(BlossomFont.headline)
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            viewModel.isProcessing
                            ? Color(red: 0.4, green: 0.45, blue: 0.95).opacity(0.7)
                            : Color(red: 0.4, green: 0.45, blue: 0.95)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .disabled(viewModel.isProcessing)

                    // MARK: - Powered by Stripe
                    HStack(spacing: 6) {
                        Text("Powered by")
                            .font(BlossomFont.caption)
                            .foregroundStyle(.white.opacity(0.35))
                        Image(systemName: "creditcard")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.35))
                        Text("Stripe")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.45))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color(red: 0.067, green: 0.078, blue: 0.149))
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(viewModel.isProcessing)
        .sensoryFeedback(.success, trigger: viewModel.state) { _, newValue in
            newValue == .success
        }
        .onChange(of: viewModel.state) { _, newValue in
            if newValue == .success {
                onSuccess()
                dismiss()
            }
        }
        .disabled(viewModel.state == .success)
    }
}

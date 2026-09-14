import SwiftUI
import WebKit

struct SourcePaperView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PaperWebView(url: URL(string: "https://pastpapers.papacambridge.com/papers/caie/viewer/caie/o-level-biology-5090-2026-may-june-5090-s26-qp-11-pdf")!)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("Original 5090/11 paper")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct PaperWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        let view = WKWebView(frame: .zero, configuration: config)
        view.allowsBackForwardNavigationGestures = true
        view.scrollView.contentInsetAdjustmentBehavior = .automatic
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

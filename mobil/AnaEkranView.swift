import SwiftUI

struct AdminAnaEkranView: View {
    @State private var oturumAcik: Bool = true // Oturum durumu

    var body: some View {
        if oturumAcik {
            NavigationView {
                TabView {
                    AdminKitaplarView()
                        .tabItem {
                            Label("Kitaplar", systemImage: "book")
                        }

                    AdminOgrencilerView()
                        .tabItem {
                            Label("Öğrenciler", systemImage: "person.2")
                        }
                }
                .navigationTitle("Admin Paneli")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            oturumAcik = false // Çıkış işlemi
                        }) {
                            Text("Çıkış Yap")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        } else {
            LoginView()
        }
    }
}

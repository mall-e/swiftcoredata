import SwiftUI
import CoreData

struct AdminOgrenciKitaplarView: View {
    @ObservedObject var ogrenci: Kullanici
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kitap.baslik, ascending: true)],
        animation: .default)
    private var kitaplar: FetchedResults<Kitap>

    var body: some View {
        VStack {
            Text("\(ogrenci.kullaniciAdi ?? "Bilinmiyor")'ın Kitapları")
                .font(.title)
                .padding()

            List {
                ForEach(kitaplar) { kitap in
                    HStack {
                        Text(kitap.baslik ?? "Bilinmiyor")
                        Spacer()
                        Text(okunduMu(kitap: kitap) ? "Okundu" : "Okunmadı")
                            .foregroundColor(okunduMu(kitap: kitap) ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle("Kitaplar")
    }

    private func okunduMu(kitap: Kitap) -> Bool {
        // Öğrencinin okunan kitaplar ilişkisini kontrol ediyoruz
        if let okunanKitaplar = ogrenci.okunanKitaplar as? Set<Kitap> {
            return okunanKitaplar.contains(kitap)
        }
        return false
    }
}

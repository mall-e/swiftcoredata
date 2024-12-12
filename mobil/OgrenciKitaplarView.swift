import SwiftUI
import CoreData

struct OgrenciKitaplarView: View {
    @ObservedObject var ogrenci: Kullanici
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest private var kitaplar: FetchedResults<Kitap>
    
    init(ogrenci: Kullanici) {
        self.ogrenci = ogrenci
        let fetchRequest: NSFetchRequest<Kitap> = Kitap.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Kitap.baslik, ascending: true)]
        _kitaplar = FetchRequest(fetchRequest: fetchRequest)
    }

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
                        Button(action: {
                            okumaDurumunuGuncelle(kitap: kitap)
                        }) {
                            Text(okunduMu(kitap: kitap) ? "Okundu" : "Okunmadı")
                                .foregroundColor(okunduMu(kitap: kitap) ? .green : .red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Kitaplar")
    }

    private func okunduMu(kitap: Kitap) -> Bool {
        guard let okunanKitaplar = ogrenci.okunanKitaplar as? Set<Kitap> else {
            return false
        }
        return okunanKitaplar.contains(kitap)
    }

    private func okumaDurumunuGuncelle(kitap: Kitap) {
        withAnimation {
            // Mevcut okunanKitaplar set'ini al
            let okunanKitaplar = ogrenci.mutableSetValue(forKey: "okunanKitaplar")
            
            // Kitap zaten set'te varsa çıkar, yoksa ekle
            if okunanKitaplar.contains(kitap) {
                okunanKitaplar.remove(kitap)
            } else {
                okunanKitaplar.add(kitap)
            }
            
            // Değişiklikleri kaydet
            do {
                try viewContext.save()
            } catch {
                print("Okuma durumu kaydedilirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}

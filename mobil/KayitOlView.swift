import SwiftUI
import CoreData

struct KayitOlView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var kullaniciAdi: String = ""
    @State private var sifre: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Kayıt Ol")
                .font(.largeTitle)
                .bold()

            TextField("Kullanıcı Adı", text: $kullaniciAdi)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            SecureField("Şifre", text: $sifre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            Button(action: kayitOl) {
                Text("Kayıt Ol")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
    }

    private func kayitOl() {
        guard !kullaniciAdi.isEmpty && !sifre.isEmpty else {
            print("Kullanıcı adı ve şifre boş olamaz!")
            return
        }

        let yeniKullanici = Kullanici(context: viewContext)
        yeniKullanici.id = UUID()
        yeniKullanici.kullaniciAdi = kullaniciAdi
        yeniKullanici.sifre = sifre
        yeniKullanici.isAdmin = false

        do {
            try viewContext.save()
            print("Kullanıcı başarıyla kaydedildi!")
        } catch {
            print("Kullanıcı kaydedilemedi: \(error.localizedDescription)")
        }
    }

}

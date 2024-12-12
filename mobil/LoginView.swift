import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var kullaniciAdi: String = ""
    @State private var sifre: String = ""
    @State private var hataMesaji: String = ""
    @State private var oturumAcik: Bool = false
    @State private var isAdmin: Bool = false

    var body: some View {
        if oturumAcik {
            if isAdmin {
                AdminAnaEkranView()
            } else {
                OgrenciContentView()
            }
        } else {
            VStack(spacing: 20) {
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .bold()

                TextField("Kullanıcı Adı", text: $kullaniciAdi)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)

                SecureField("Şifre", text: $sifre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)

                Button(action: girisYap) {
                    Text("Giriş Yap")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)

                if !hataMesaji.isEmpty {
                    Text(hataMesaji)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: kayitOl) {
                    Text("Kayıt Ol")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }

    private func girisYap() {
        if kullaniciAdi == "Admin" && sifre == "admin" {
            isAdmin = true
            oturumAcik = true
        } else {
            let fetchRequest: NSFetchRequest<Kullanici> = Kullanici.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "kullaniciAdi == %@ AND sifre == %@", kullaniciAdi, sifre)

            do {
                let sonuc = try viewContext.fetch(fetchRequest)
                if let kullanici = sonuc.first {
                    isAdmin = kullanici.isAdmin
                    oturumAcik = true
                } else {
                    hataMesaji = "Kullanıcı adı veya şifre hatalı."
                }
            } catch {
                hataMesaji = "Bir hata oluştu: \(error.localizedDescription)"
            }
        }
    }

    private func kayitOl() {
        guard !kullaniciAdi.isEmpty && !sifre.isEmpty else {
            hataMesaji = "Kullanıcı adı ve şifre boş olamaz!"
            return
        }

        let yeniKullanici = Kullanici(context: viewContext)
        yeniKullanici.id = UUID()
        yeniKullanici.kullaniciAdi = kullaniciAdi
        yeniKullanici.sifre = sifre
        yeniKullanici.isAdmin = false

        do {
            try viewContext.save()
            hataMesaji = "Kayıt başarılı! Giriş yapabilirsiniz."
        } catch {
            hataMesaji = "Kayıt sırasında bir hata oluştu."
        }
    }
}

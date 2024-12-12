import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true) // Sadece önizleme için
        let viewContext = result.container.viewContext

        // Örnek veriler ekle (isteğe bağlı)
        let kitap = Kitap(context: viewContext)
        kitap.id = UUID()
        kitap.baslik = "Örnek Kitap"
        kitap.yazar = "Örnek Yazar"
        kitap.tur = "Roman"
        kitap.okunduMu = false

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "mobil")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

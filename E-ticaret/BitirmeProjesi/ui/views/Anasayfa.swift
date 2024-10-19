//
//  ViewController.swift
//  BitirmeProjesi
//
//  Created by Burak Satır on 8.10.2024.
//


import UIKit
import Kingfisher

class Anasayfa: UIViewController {
    
    @IBOutlet weak var urunlerColletionView: UICollectionView!
    
    var urunlerListesi = [Urunler]()  // Tüm ürünlerin tutulduğu orijinal liste
    var filtrelenmisUrunlerListesi = [Urunler]()  // Filtrelenmiş ürünler burada tutulacak
    var viewModel = AnasayfaViewModel()
    let kullaniciAdi = "buraksatir" // Dinamik olarak kullanıcı adı
    
    var isSearching = false
    let searchBar = UISearchBar()
    let greetingLabel = UILabel()
    let searchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = greetingLabel
        urunlerColletionView.delegate = self
        urunlerColletionView.dataSource = self
        
        // Ürünleri ViewModel'den yükle
        _ = viewModel.urunlerListesi.subscribe(onNext: { liste in
            self.urunlerListesi = liste
            self.filtrelenmisUrunlerListesi = liste // Başlangıçta tüm ürünleri göster
            DispatchQueue.main.async {
                self.urunlerColletionView.reloadData()
            }
        })
        
        // Navigation Bar Kişiselleştirilmiş Selamlama ve Arama
        setupNavigationBar()
        
        // TabBar Tasarım
        setupTabBarAppearance()
        
        // CollectionView Tasarımı
        setupCollectionViewDesign()
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        
        renkDegistir(itemAppearance: appearance.stackedLayoutAppearance)
        renkDegistir(itemAppearance: appearance.compactInlineLayoutAppearance)
        renkDegistir(itemAppearance: appearance.inlineLayoutAppearance)
        
        tabBarController?.tabBar.standardAppearance = appearance
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }
    
    func renkDegistir(itemAppearance: UITabBarItemAppearance) {
        itemAppearance.selected.iconColor = UIColor(named: "Color1")
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "Color1")!]
    }
    
    func setupCollectionViewDesign() {
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 30) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.7)
        urunlerColletionView.collectionViewLayout = tasarim
    }
    
    func setupNavigationBar() {
        greetingLabel.text = "Ürünler"
        greetingLabel.textColor = .white
        greetingLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        greetingLabel.textAlignment = .center
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        setupSearchBar()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Color1")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupSearchBar() {
        searchBar.isHidden = true
        searchBar.delegate = self
        searchBar.placeholder = "Arama yap..."
        searchBar.searchTextField.backgroundColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Arama yap...", attributes: placeholderAttributes)
        searchBar.barTintColor = UIColor(named: "Color1")
    }
    
    @objc func toggleSearchBar() {
        if isSearching {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.alpha = 0
                self.greetingLabel.alpha = 1
            }) { _ in
                self.searchBar.isHidden = true
                self.greetingLabel.isHidden = false
                self.searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
                self.searchBar.resignFirstResponder()
            }
        } else {
            self.searchBar.isHidden = false
            self.greetingLabel.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.alpha = 1
                self.greetingLabel.alpha = 0
            }) { _ in
                self.searchButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                self.searchBar.becomeFirstResponder()
            }
        }
        isSearching.toggle()
        navigationItem.titleView = isSearching ? searchBar : greetingLabel
    }
    
    @IBAction func buttonFiltrele(_ sender: Any) {
        showCategoryFilterOptions()
    }
    
    @IBAction func buttonSiralama(_ sender: Any) {
        showSortOptions()
    }
    
    @objc func showCategoryFilterOptions() {
        let actionSheet = UIAlertController(title: "Kategoriye Göre Filtrele", message: nil, preferredStyle: .actionSheet)
        let onerilenAction = UIAlertAction(title: "Tüm Kategoriler", style: .default, handler: { action in
            self.filtrelenmisUrunlerListesi = self.urunlerListesi
            self.urunlerColletionView.reloadData()
        })
        
        let kategoriHandler: (String) -> (UIAlertAction) -> Void = { kategori in
            return { action in
                self.filtrelenmisUrunlerListesi = self.viewModel.filtreleKategorisineGore(kategori: kategori)
                self.urunlerColletionView.reloadData()
            }
        }
        
        let aksesuarAction = UIAlertAction(title: "Aksesuar", style: .default, handler: kategoriHandler("Aksesuar"))
        let teknolojiAction = UIAlertAction(title: "Teknoloji", style: .default, handler: kategoriHandler("Teknoloji"))
        let kozmetikAction = UIAlertAction(title: "Kozmetik", style: .default, handler: kategoriHandler("Kozmetik"))
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        actionSheet.addAction(onerilenAction)
        actionSheet.addAction(aksesuarAction)
        actionSheet.addAction(teknolojiAction)
        actionSheet.addAction(kozmetikAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func showSortOptions() {
        let actionSheet = UIAlertController(title: "Sırala", message: nil, preferredStyle: .actionSheet)
        
        let sortHandler: (UIAlertAction) -> Void = { action in
            self.filtrelenmisUrunlerListesi = self.viewModel.sortByPriceAscending()
            self.urunlerColletionView.reloadData()
        }
        
        actionSheet.addAction(UIAlertAction(title: "Artan Fiyat", style: .default, handler: sortHandler))
        actionSheet.addAction(UIAlertAction(title: "Azalan Fiyat", style: .default, handler: { action in
            self.filtrelenmisUrunlerListesi = self.viewModel.sortByPriceDescending()
            self.urunlerColletionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "A'dan Z'ye", style: .default, handler: { action in
            self.filtrelenmisUrunlerListesi = self.viewModel.sortByAlphabetAscending()
            self.urunlerColletionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Z'den A'ya", style: .default, handler: { action in
            self.filtrelenmisUrunlerListesi = self.viewModel.sortByAlphabetDescending()
            self.urunlerColletionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension Anasayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filtrelenmisUrunlerListesi = urunlerListesi
        } else {
            filtrelenmisUrunlerListesi = urunlerListesi.filter { $0.ad!.lowercased().contains(searchText.lowercased()) }
        }
        urunlerColletionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleSearchBar()
    }
}

extension Anasayfa: UICollectionViewDelegate, UICollectionViewDataSource, UrunlerProtocol {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrelenmisUrunlerListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: "urunlerHucre", for: indexPath) as! UrunlerHucre
        let urun = filtrelenmisUrunlerListesi[indexPath.row]
        
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim!)") {
            DispatchQueue.main.async {
                hucre.imageViewUrun.kf.setImage(with: url)
            }
        }
        
        hucre.labelAd.text = urun.ad
        hucre.labelFiyat.text = "\(urun.fiyat!) ₺"
        
        hucre.layer.borderColor = UIColor.lightGray.cgColor
        hucre.layer.borderWidth = 0.3
        hucre.layer.cornerRadius = 10
        
        hucre.urunlerProtocol = self
        hucre.urun = urun
        
        return hucre
    }
    
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        viewModel.sepeteEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti, kullaniciAdi: kullaniciAdi)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urun = filtrelenmisUrunlerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: urun)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let urun = sender as? Urunler {
                let gidilcekVC = segue.destination as! DetaySayfa
                gidilcekVC.urun = urun
            }
        }
    }
}

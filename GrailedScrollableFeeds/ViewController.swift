//
//  ViewController.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/4/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    var rootArticle: ArticleViewModel = ArticleViewModel()
    var rootSearch: SavedSearchViewModel = SavedSearchViewModel()
    var metaPagination: Metadata?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        self.navigationItem.title = "Scrollable Feeds"
        //MARK: Set up Layout
        setUpLayout()
        //MARK: Add Targets
        segmentedControl.addTarget(self, action: #selector(segmentedIndexSelected(_:)), for: .touchUpInside)
        //MARK: Retrieve article data
        articleBinding()
        //MARK: Retrieve Saved Search data
        savedSearchBinding()
    }
    
    //MARK: DATASOURCES
    var sections: Int = 0
    var articles: [ArticleViewModel]? {
        didSet {
            heroCollection.reloadData()
        }
    }
    
    var searches: [SavedSearchViewModel]? {
        didSet {
            heroCollection.reloadData()
        }
    }
    
    //MARK: UI COMPONENTS
    lazy var segmentedControl: UISegmentedControl = {
        var items = ["Article API", "Saved Search API"]
        var control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedIndexSelected(_:)), for: .valueChanged)
        control.addTarget(self, action: #selector(segmentedIndexSelected(_:)), for: .touchUpInside)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    
    lazy var heroCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width * 0.90, height: view.bounds.height * 0.4)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        layout.minimumLineSpacing = 85
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        collection.register(ScrollableCollectionViewCell.self, forCellWithReuseIdentifier: "heroCell")
        collection.tag = 1
        return collection
    }()
    
    //Set Up Layout
    func setUpLayout() {
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.12).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        view.addSubview(heroCollection)
        heroCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5).isActive = true
        heroCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heroCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        heroCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
    }
    
    


}

extension ViewController {
    
    //MARK: Fetches articles and binds them to article's array
    func articleBinding() {
        
        rootArticle.captureArticles { (articleVMs) in
            self.articles = articleVMs
        }
    }
    
    //MARK: Fetches searches and binds them to searches array
    func savedSearchBinding() {
        rootSearch.captureSavedSearches { (searchVMs) in
            self.searches = searchVMs
        }
    }
    
    @objc func segmentedIndexSelected(_ sender: UISegmentedControl) {
        heroCollection.reloadData()
    }
    
    func paginationIntiated() {
        rootArticle.captureArticles { (articleVMs) in
            //This solution won't scale O(n^2) Complexity
            var localArticles: [ArticleViewModel] = []
            articleVMs.forEach { article in
                let isPresent = self.articles?.contains { $0 == article }
                if isPresent == false {
                    localArticles.append(article)
                }
            }
            
            self.articles?.append(contentsOf: localArticles)
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard let articles = articles else {return 0}
            return articles.count
        case 1:
            guard let searches = searches else { return 0}
            return searches.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroCell", for: indexPath) as! ScrollableCollectionViewCell
        let size = Int(view.bounds.width * 0.80)

        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //TO DO: Retrieve article array from Dictionary
            guard let articles = articles else {
                print("Doesn't Work")
                return cell
            }
            
            if indexPath.item == articles.count - 1 {
                paginationIntiated()
            }
            
            let article = articles[indexPath.item]
            let link = article.imageSizeResolverUrl(size: size)
            cell.configureImage(url: link)
            cell.title.text = article.title
            guard let publishedDate = article.published_at else { return cell }
            cell.whenPublished.text = "Published: \(publishedDate)"
            return cell
        case 1:
            guard let searches = searches else {return cell}
            let search = searches[indexPath.row]
            let link = search.imageSizeResolverUrl(size: size)
            cell.configureImage(url: link)
            cell.title.text = search.name
            guard let publishedDate = search.published else { return cell }
            cell.whenPublished.text = publishedDate
            return cell
        default:
            return cell
        }
        
    }
    
    
    
}


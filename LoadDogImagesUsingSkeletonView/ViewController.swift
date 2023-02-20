//
//  ViewController.swift
//  LoadDogImagesUsingSkeletonView
//
//  Created by Vikram Kunwar on 20/02/23.
//

import UIKit
import SkeletonView

class ViewController: UIViewController {

    @IBOutlet weak var tableVC: UITableView!
    
    var dogAllData:DogsData?
    var dogAllImageLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now()+5)
        {
            self.tableVC.stopSkeletonAnimation()
            self.tableVC.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                                      self.tableVC.reloadData()
                                      
                                      
        }
        
    }
    
    func fetchData(){
        
        let url = URL(string: "https://dog.ceo/api/breed/hound/images")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data,response,error) in
            guard let data = data , error == nil else{
                
                print("Error Occured While Accessing Data")
                return
            }
            var dogObject: DogsData?
            do
            {
                dogObject = try JSONDecoder().decode(DogsData.self, from: data)
                
            }
            catch
            {
                print("Error While Decoding Data into Swift Structure \(error)")
            }
            self.dogAllData = dogObject
            self.dogAllImageLinks = self.dogAllData!.message
            DispatchQueue.main.async {
                self.tableVC.reloadData()
            }
            
            
        })
        task.resume()
        
    }


}
extension UIImageView
{
    func downloadImage(fron url: URL ,cell :UITableViewCell)
    {
        
        image = nil
        cell.showAnimatedGradientSkeleton()
        contentMode = .scaleToFill
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            
            guard let httpUrlResponse = response as? HTTPURLResponse , httpUrlResponse.statusCode == 200 , let mimType = response?.mimeType ,mimType.hasPrefix("image"),
                  let data = data,error == nil,
                  let image = UIImage(data: data)
                    else
            {
                print("Error while accessing data")
                return
            }
            DispatchQueue.main.async {
                self.image = image
                cell.stopSkeletonAnimation()
                cell.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                cell.layer.cornerRadius = 25
            }
            
        })
        dataTask.resume()
    }
}
extension ViewController: SkeletonTableViewDataSource,SkeletonTableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogAllImageLinks.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogAllImageLinks.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVC.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogsTVC
        let urlImage = URL(string: dogAllImageLinks[indexPath.row])
        cell.dogImages.layer.cornerRadius = 25
        cell.dogImages.downloadImage(fron: urlImage!, cell: cell)
        return cell
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableVC.showAnimatedGradientSkeleton()
    }
    
    
}


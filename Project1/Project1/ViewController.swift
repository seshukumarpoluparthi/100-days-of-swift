import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async(execute: loadImages)
    }

    func loadImages() {
        let fm = FileManager.default
        let bundlePath = Bundle.main.resourcePath!

        pictures = (try! fm.contentsOfDirectory(atPath: bundlePath))
            .filter {
                $0.hasPrefix("nssl")
            }
            .sorted()

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        vc.selectedImage = pictures[indexPath.row]
        vc.totalImages = pictures.count
        vc.selectedImagePosition = indexPath.row + 1
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

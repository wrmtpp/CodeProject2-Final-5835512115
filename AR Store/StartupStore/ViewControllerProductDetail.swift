
import UIKit

class ViewControllerProductDetail: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonAddCart: UIButton!
    @IBOutlet weak var labelDetail: UILabel!
    
    let fileManager = FileManager.default
    let fileName = "db.sqlite"
    var db: FMDatabase!
    var dbPath: String!
    var sql: String!
    var resultSet: FMResultSet!
    
    var product_id = Int()
    var name = String()
    var detail = String()
    var price = Double()
    var stock = Int32()
    var imgString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        dbPath = urls[0].appendingPathComponent(fileName).path
        db = FMDatabase(path: dbPath)
        db.open()
        
        sql =   "SELECT * FROM product " +
                "WHERE product_id = \(product_id)"

        do {
            resultSet = try db.executeQuery(sql, values: nil)
            resultSet.next()
            
            product_id = Int(resultSet.int(forColumn: "product_id"))
            name = resultSet.string(forColumn: "product_name")!
            detail = resultSet.string(forColumn: "detail")!
            price = resultSet.double(forColumn: "price")
            stock = resultSet.int(forColumn: "stock_unit")
            imgString = resultSet.string(forColumn: "image")!
            
        } catch { print(error.localizedDescription) }
        
        let images = imgString.components(separatedBy: ",")
        var imageSources = [ImageSource]()
        
        for img in images {
            imageSources.append(ImageSource(imageString: img)!)
        }
        
        slideshow.setImageInputs(imageSources)
        slideshow.backgroundColor = UIColor.white
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageControl.currentPageIndicatorTintColor =
            UIColor.lightGray
        
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()

        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(slideShowDidTap))
        
        slideshow.addGestureRecognizer(recognizer)
        
        labelProductName.text = name
        labelProductName.font = UIFont.boldSystemFont(ofSize: 20)
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let r = price.truncatingRemainder(dividingBy: 1)
        var p = " "
        if r == 0 {
            let n = Int(price)
            p = format.string(for: n)!
        } else {
            p = format.string(for: price)!
        }
        labelPrice.text = "\(p) บาท"
        
        // ###########  ฟังก์ชันของหมด ###########
        
        if stock <= 0 {
            buttonAddCart.isEnabled = false
            buttonAddCart.setTitleColor(UIColor.red, for: .normal)
            buttonAddCart.setTitle("สินค้าหมด", for: .normal)
        }
        
        labelDetail.text = detail
        db.close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        updateBadge()
    }
    
    @objc func slideShowDidTap() {
        let fullScreenController =
            slideshow.presentFullScreenController(from: self)
        
        fullScreenController.slideshow.activityIndicator =
            DefaultActivityIndicator(style: .white, color: nil)
        
        fullScreenController.closeButton.setImage(
            UIImage(named: "close")!,
            for: .normal)
    }

    func updateBadge() {
        var n = Int32()
        sql = "SELECT SUM(quantity) FROM cart"
        
        if !db.isOpen {
            db.open()
        }
        
        do {
            resultSet = try db.executeQuery(sql, values: nil)
            resultSet.next()
            n = resultSet.int(forColumnIndex: 0)
        } catch { print(error.localizedDescription) }
        
        if n >= 1 {
            tabBarController?.tabBar.items?[2].badgeValue = "\(n)"
        }
        
        db.close()
    }
    
    @IBAction func buttonAddCartDidTap(_ sender: UIButton) {
        sql = "INSERT INTO cart VALUES (?,?,?,?,?,?)"
        
        if !db.isOpen {
            db.open()
        }
        
        do {
            _ = try db.executeUpdate(
                        sql, values: [product_id,name,
                                      price, stock, 1, imgString])
        } catch {
            print(error.localizedDescription)
        }
        
        db.close()
        
        updateBadge()
        Drop.down("หยิบใส่รถเข็นแล้ว")
    }
    
}


import UIKit



//คลาสสำหรับจัดเก็บข้อมูลของแต่ละแถว
class Product {
    var product_id: Int32
    var product_name: String
    var detail: String
    var stock_unit: Int32
    var price: Double
    var image: String
    
    init(id: Int32, name: String, detail: String, stock: Int32, price: Double, image: String) {
        self.product_id = id
        self.product_name = name
        self.price = price
        self.detail = detail
        self.stock_unit = stock
        self.image = image
    }
}

class ViewControllerMain: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let fileManager = FileManager.default
    let fileName = "db.sqlite"
    var db: FMDatabase!
    var dbPath: String!
    var sql: String!
    var resultSet: FMResultSet!
    
    var data = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        dbPath = urls[0].appendingPathComponent(fileName).path
        db = FMDatabase(path: dbPath)
        db.open()
        
        createData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        readData()
        
        
    }

    func createData() {
        sql =  "CREATE TABLE IF NOT EXISTS product " +
                "(product_id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "product_name TEXT, " +
                "detail TEXT, " +
                "price REAL, " +
                "stock_unit INTEGER, " +
                "image TEXT)"
        
        db.executeStatements(sql)
        
        sql =   "INSERT INTO product VALUES " +
                "('1', 'Koloze Bed', 'เตียงหนังสังเคราะห์เข้ามุมโคโรเซ่-อี สไตล์คอนเทนโพรารี่ ขนาด W193 x D208 x H90 ซม. หนังสังเคราะห์คุณภาพดีเกรด เอ อายุการใช้งานของหนังสังเคราะห์ (Synthetic Leather) ภายใต้การใช้งานปกติและการดูแลรักษาที่เหมาะสม สามารถใช้งานได้มากกว่า 2 ปี มีทั้งมุมซ้าและมุมขวา มีให้เลือก 2 สี สีน้ำตาลและสีดำ', '15000', '1', 'p11,p12,p13'), " +
            
                "('2', 'Nimega Chair', 'เก้าอี้เบดผ้า นิเมก้า สไตล์โมเดิร์น ขนาด W120 x D50 X H60 ซม. โครงสร้างไม้จริงแข็งแรงทนทาน หุ้มด้วยผ้าคุณภาพนำเข้าจากต่างประเทศนุ่มสบาย ไม่หดตัว สามารถปรับเอนนอน อายุการใช้งานนาน พร้อมหมอน 1 ใบ', '1500', '1', 'p21,p22,p23,p24'), " +
            
                "('3', 'Modern Chair', 'เก้าอี้พลาสติกสีเเดงว แม็กซิมัส ขนาด 240 ซม. สไตล์โมเดิร์น สวยงามด้วยพลาสติกธรรมชาติตัดกับวัสดุไฮ-กลอสสีเเดงเงางาม มีให้เลือก 3 สี ได้แก่ สีวอลนัท, สีเวงเก้ และโซลิคโอ๊ค ', '3000', '0', 'p31,p32,p33,p34'), " +
                "('4', 'Syntas Table', 'โต๊ะอาหารขาเหล็กท๊อปกระจก โต๊ะอาหารขนาด 80-119 (90x90x72 cm.W x D x H)' , '2300', '1', 'p81,p82'), " +
               
                "('5', 'Crystal Lamp', 'โคมไฟอเนกประสงค์ สไตล์โมเดิร์น สว่างไกลถึง 5 เมตร เหมาะแก่การไว้ในห้อง 30 ซม.' , '500', '1', 'p41,p42'), " +
                "('6', 'Vase', 'กระถางใส่ดอกไม้สไตล์โมเดิร์น สีเเดง 20x8x20 เซนติเมตร ' , '800', '1', 'p51,p52'), " +
                "('7', 'Bed', 'เตียงหนังสังเคราะห์เข้ามุมโคโรเซ่-อี สไตล์คอนเทนโพรารี่ ขนาด W193 x D208 x H90 ซม. ' , '10800', '1', 'p61,p62'), " +
                "('8', 'Chair', 'เก้าอี้ไตล์โมเดิร์นสีขาว ขนาด W120 x D50 X H60 ซม. ' , '1800', '1', 'p71,p72') "

        
          
        
        db.executeStatements(sql)
        sql =   "CREATE TABLE IF NOT EXISTS cart " +
                "(product_id INTEGER PRIMARY KEY, " +
                "product_name TEXT, " +
                "price REAL, " +
                "stock_unit INTEGER, " +
                "quantity INTEGER, " +
                "image TEXT)"
        
        db.executeStatements(sql)
        db.close()
    }
    
    func readData() {
        sql = "SELECT * FROM product"
        
        var product: Product
        
        var id: Int32
        var name: String
        var detail: String
        var price: Double
        var stock: Int32
        var image: String
        
        do {
            if !db.isOpen {
                db.open()
            }
            resultSet = try db.executeQuery(sql, values: nil)
            
            while(resultSet.next()) {
                id = resultSet.int(forColumn: "product_id")
                name = resultSet.string(forColumn: "product_name")!
                detail = resultSet.string(forColumn: "detail")!
                price = resultSet.double(forColumn: "price")
                stock = resultSet.int(forColumn: "stock_unit")
                image = resultSet.string(forColumn: "image")!
                
                product = Product(id: id, name: name, detail: detail,
                                  stock: stock, price: price, image: image)
                
                data.append(product)
            }
            
            db.close()
            
        } catch { print(error.localizedDescription) }
        
        collectionView.reloadData()
    }
    
    func clearCart() {
        if !db.isOpen {
            db.open()
        }
        sql = "DELETE FROM cart"
        db.executeStatements(sql)
        db.close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        updateBadge()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionCell",
            for: indexPath) as! CollectionViewCell
        
        let item = indexPath.item
        
        let images = data[item].image.components(separatedBy: ",")
        cell.imageView.image = UIImage(named: images[0])
        
        cell.labelTitle.text = data[item].product_name
        
        cell.tag = Int(data[item].product_id)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 10
        
        return cell
    }

    func updateBadge() {
        sql = "SELECT SUM(quantity) FROM cart"
        do {
            if !db.isOpen {
                db.open()
            }
            resultSet = try db.executeQuery(sql, values: nil)

        } catch { print(error.localizedDescription) }
        
        resultSet.next()
        let n = resultSet.int(forColumnIndex: 0)
        if n >= 1 {
            tabBarController?.tabBar.items?[2].badgeValue = "\(n)"
        }
        db.close()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let items = collectionView.indexPathsForSelectedItems
        let cell = collectionView.cellForItem(at: items![0])
        
        let vcDetail = segue.destination as! ViewControllerProductDetail
        if let id = cell?.tag {
            vcDetail.product_id = id
        }
    }
 
}


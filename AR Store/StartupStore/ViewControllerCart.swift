import UIKit
//เนื่องจากสินค้าในรถเข็น อาจมีมากกว่า 1 รายการ
//จึงต้องสร้างคลาสเพื่อเก็บข้อมูลของแต่ละแถว
class Cart {
    var product_id: Int32
    var product_name: String
    var price: Double
    var stock_unit: Int32
    var quantity: Int32
    var image: String
    
    init(id: Int32, name: String, price: Double,
         stock: Int32, quantity: Int32, image: String) {
        
        self.product_id = id
        self.product_name = name
        self.price = price
        self.stock_unit = stock
        self.quantity = quantity
        self.image = image
    }
}

class ViewControllerCart: UIViewController,
UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButtonItemDelete: UIBarButtonItem!
    @IBOutlet weak var labelGrandTotal: UILabel!
    @IBOutlet weak var labelTextTotal: UILabel!
    
    @IBOutlet weak var barButtonItemOk: UIBarButtonItem!
    
    
    let fileManager = FileManager.default
    let fileName = "db.sqlite"
    var db: FMDatabase!
    var dbPath: String!
    var sql: String!
    var resultSet: FMResultSet!
    
    var data = [Cart]()
    var grandTotal: Double = 0
    
    var format = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        format.numberStyle = .decimal  //จัดรูปแบบของตัวเลข
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        dbPath = urls[0].appendingPathComponent(fileName).path
        db = FMDatabase(path: dbPath)
        
        if !db.isOpen {
            db.open()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
        
        //ถ้ามีสินค้าในรถเข็น ให้แสดงคำแจ้งเตือนว่าต้องคลิกปุ่ม คำนวณใหม่
        //เพื่อให้ข้อมูลถูกบันทึก
        if tableView.numberOfRows(inSection: 0) > 0 {
            Drop.down("สามารถกดเพิ่มลดจำนวนสินค้าได้\nราคาจะอัพเดทอัตโนมัติ",
                      state: .error, duration: 4.0, action: nil)
        } else {
            setEmptyCartStatus()  //ถ้าไม่มีสินค้าในรถเข็น
        }
    }
    
    //เมธอดสำหรับเซตค่าต่างๆ ให้สอดคล้องกันเมื่อไม่มีสินค้ารถเข็น
    func setEmptyCartStatus() {
        navigationController?.navigationBar.isHidden = true
        labelTextTotal.text = "ไม่มีสินค้าในรถเข็น"
        labelGrandTotal.isHidden = true
    }
    
    //อ่านข้อมูลจากตาราง Cart
    func readData() {
        sql = "SELECT * FROM cart"
        
        var cart: Cart
        
        var id: Int32
        var name: String
        var price: Double
        var stock: Int32
        var quan: Int32
        var img: String
        
        grandTotal = 0
        data.removeAll()
        
        if !db.isOpen {
            db.open()
        }
        
        do {
            resultSet = try db.executeQuery(sql, values: nil)
            
            while(resultSet.next()) {
                id = resultSet.int(forColumn: "product_id")
                name = resultSet.string(forColumn: "product_name")!
                price = resultSet.double(forColumn: "price")
                stock = resultSet.int(forColumn: "stock_unit")
                quan = resultSet.int(forColumn: "quantity")
                img = resultSet.string(forColumn: "image")!
                
                cart = Cart(id: id, name: name, price: price, stock: stock,
                            quantity: quan, image: img)
                
                data.append(cart)
            }
            
            db.close()
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    //จำนวนแถวของ Table View
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    //กำหนดข้อมูลจากอาร์เรย์ให้กับ Cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TableCell")
                as! TableViewCell
            
            let row = indexPath.row
            
            //สำหรับรูปภาพ เราก็คัดแยกชื่อของมันด้วย "," แล้วนำมาแสดงเฉพาะภาพแรก
            let images = data[row].image.components(separatedBy: ",")
            cell.imgView.image = UIImage(named: images[0])
            
            cell.labelName.text = data[row].product_name
            
            //ราคา ให้จัดรูปแบบตัวเลข
            let p = data[row].price
            cell.labelPrice.text = "ราคา: \(numFormat(num:p))"
            
            //จำนวนสินค้า ให้กำหนดค่า maximum ได้ไม่เกินจำนวนที่มีในสต๊อก
            let q = data[row].quantity
            cell.stepperQuantity.value = Double(q)
            cell.stepperQuantity.maximumValue = Double(data[row].stock_unit)
            
            //ผลรวมย่อยของสินค้าแต่ละชนิด และจัดรูปแบบตัวเลข
            let subtotal = p * Double(q)
            cell.labelSubtotal.text = "\(numFormat(num:subtotal))"
            
            //เพิ่มผลรวมย่อยเข้าไปในผลรวมทั้งหมด (จะนำค่านี้ไปแสดงใน Label)
            grandTotal += subtotal
            
            //เก็บค่า id ของสินค้าไว้กับ tag เผื่อนำไปใช้เป็นเงื่อนไขในการลบ
            cell.tag = Int(data[row].product_id)
            
            //ถ้าเป็นแถวสุดท้าย (แสดงว่ามีสินค้าในรถเข็น)
            //ก็ให้แสดงแถบ Nav Bar และ Label ที่ระบุมูลค่ารวม
            //เพราะในกรณีที่ไม่มีสินค้า เราจะซ่อนส่วนนี้ (ดูที่เมธอด setEmptyCartStatus)
            if row == (data.count - 1) {
                navigationController?.navigationBar.isHidden = false
                labelTextTotal.text = "รวมทั้งสิ้น"
                labelGrandTotal.isHidden = false
                labelGrandTotal.text = "\(numFormat(num: grandTotal))"
            }
            
            return cell
    }
    
    
    //กดสั่งซื้อ
    @IBAction func barButtonItemOk(_ sender: UIBarButtonItem) {
        
            if tableView.numberOfRows(inSection: 0) > 0 {
                Drop.down("สั่งซื้อเสร็จสิ้น", state: .error, duration: 4.0, action: nil)
                self.sql = "DELETE FROM cart "
                
                if !self.db.isOpen {
                    self.db.open()
                }
                
                do {
                    _ = try self.db.executeUpdate(self.sql, values: nil)
                } catch {
                    print(error.localizedDescription)
                }
                
                self.db.close()
                readData()
                updateBadge()

        }
            else {
                setEmptyCartStatus()  //ถ้าไม่มีสินค้าในรถเข็น
            }
        }
        

    
    //เมื่อคลิกปุ่ม ลบ บน Nav Bar ก็ให้สลับข้อความบนปุ่ม และโหมดการแก้ไขเหมือนที่เคยทำมา
    @IBAction func barButtonDeleteDidTap(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            barButtonItemDelete.title = "ลบ"
        } else {
            tableView.setEditing(true, animated: true)
            barButtonItemDelete.title = "ยกเลิก"
        }
    }
    
    //กำหนดปุ่มลบในแต่ละแถว โดยเมื่อคลิกที่ปุ่มในแถวใด ก็ให้นำค่า id จาก tag
    //ไปเป็นเงื่อนไขในการลบข้อมูลออกจากตาราง cart
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
            let btDelete = UITableViewRowAction(
                style: .default,
                title: "ลบ",
                handler: { (action, index) in
                    let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
                    guard let id = cell?.tag else {
                        return
                    }
                    self.sql = "DELETE FROM cart " +
                    "WHERE product_id = \(id)"
                    
                    if !self.db.isOpen {
                        self.db.open()
                    }
                    
                    do {
                        _ = try self.db.executeUpdate(self.sql, values: nil)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    self.db.close()
                    
                    //หลังการลบ ให้อัปเดตการแสดงผล
                    self.readData()
                    tableView.reloadData()
                    self.updateBadge()
            })
            
            return [btDelete]
    }
    
    //เมื่อคลิกปุ่ม คำนวณใหม่ เราต้องอ่านจำนวนสินค้าแต่ละชนิดจาก Stepper
    //ไปอัปเดตข้อมูลเดิมในตาราง

    @IBAction func stepper(_ sender: Any) {
    let numRows = tableView.numberOfRows(inSection: 0)
        var cell: TableViewCell
        var ipath: IndexPath
        var quantity: Int
        var id: Int
        
        if !db.isOpen {
            db.open()
        }
        //วนลูปตามจำนวนแถวของ Table View
        //แล้วอ่านจำนวนจาก Stepper และ id จาก tag
        //แล้วไปกำหนดเป็น SQL เพื่ออัปเดตข้อมูลเดิมในตาราง
        //เราต้องอัปเดตทุกแถว เพราะเราไม่ทราบล่วงหน้า ว่าลูกค้าจะแก้ไขจำนวนที่แถวใดบ้าง
        for i in 0..<numRows {
            ipath = IndexPath(row: i, section: 0)
            cell = tableView.cellForRow(at: ipath) as! TableViewCell
            quantity = Int(cell.stepperQuantity.value)
            id = cell.tag
            
            sql =   "UPDATE cart SET quantity = \(quantity) " +
            "WHERE product_id = \(id)"
            
            do {
                _ = try db.executeUpdate(sql, values: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        db.close()
        //หลังการแก้ไขจำนวน ก็ให้อัปเดตการแสดงผล
        readData()
        updateBadge()
    }
    
    //เมธอดสำหรับแสดงจำนวนสินค้าในรถเข็นที่ปุ่ม Tab Bar
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
        } catch {
            print(error.localizedDescription)
        }
        
        db.close()
        
        if n >= 1 {
            tabBarController?.tabBar.items?[2].badgeValue = "\(n)"
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = nil
            setEmptyCartStatus()
        }
    }
    
    //เมธอดสำหรับจัดรูปแบบตัวเลข (ถ้าทศนิยมเป็น .0 ให้แปลงเป็นจำนวนเต็ม)
    func numFormat(num: Double) -> String {
        let r = num.truncatingRemainder(dividingBy: 1)
        if r == 0 {
            let n = Int(num)
            return format.string(for: n)!
        } else {
            return format.string(for: num)!
        }
    }
}

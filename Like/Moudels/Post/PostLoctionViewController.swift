//
//  PostLoctionViewController.swift
//  Like
//
//  Created by szhd on 2021/12/24.
//  Copyright © 2021 likeeee. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import MJRefresh

class PostLoctionViewController: BaseViewController {

    public var didSelectedLocation: ((LocationInfo?) -> ())?
    private var locationManager : CLLocationManager!
    private var coordinate: CLLocationCoordinate2D?
    private var didLocation: Bool = false
    private var data: Array<LocationInfo> = Array()
    private var page: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "所在位置"
        configLocation()
        view.addSubview(tableView)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let `self` = self else {return}
            self.page += 1
            self.loadLocationData()
        })
    }
    
    func configLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-NavbarHeight)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationInfoCell.self, forCellReuseIdentifier: "LocationInfoCell_id")
        return tableView
    }()

}

extension PostLoctionViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let location = locations.last {
                coordinate = location.coordinate
                if !didLocation {
                    didLocation = true
                    loadLocationData()
                }
                locationManager.stopUpdatingLocation()
            }
        }
    }
}

extension PostLoctionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer?.isHidden = data.count == 0
        return self.data.count + 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationInfoCell = tableView.dequeueReusableCell(withIdentifier: "LocationInfoCell_id", for: indexPath) as! LocationInfoCell
        if indexPath.row == 0 {
            cell.configure()
        } else {
            cell.configure(with: data[indexPath.row-1])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            didSelectedLocation?(nil)
        } else {
            didSelectedLocation?(data[indexPath.row-1])
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension PostLoctionViewController {
    func loadLocationData() {
        guard let coordinate = coordinate else {return}
        print("location (%.2f, %.2f)", coordinate.longitude, coordinate.latitude)
        let req = SettingApiRequest.location(lat: coordinate.latitude,
                                             lon: coordinate.longitude,
                                             page: page)
        ApiManager.shared.request(request: req) { result in
            let data = JSON(result)
            var arr = Array<LocationInfo>()
            for json in data["pois"].arrayValue {
                arr.append(LocationInfo(fromJson: json))
            }
            if self.page > 1 {
                self.data.append(contentsOf: arr)
                self.tableView.mj_footer?.endRefreshing()
            } else {
                self.data = arr
            }
            
            self.tableView.reloadData()
        } failed: { error in
            
        }
    }
}

class LocationInfo : NSObject {
    var name : String!
    var location : String!
    var address : String!
    var distance : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        location = json["location"].stringValue
        address = json["address"].stringValue
        distance = json["distance"].stringValue
    }
}

class LocationInfoCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(80)
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.right.lessThanOrEqualTo(distanceLabel.snp.left).offset(-20)
            make.bottom.equalToSuperview().inset(12)
        }
        distanceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(addressLabel)
        }
        distanceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    func configure(with location: LocationInfo) {
        nameLabel.text = location.name
        addressLabel.text = location.address
        distanceLabel.text = location.distance + "m"
    }
    func configure() {
        nameLabel.text = "不显示位置"
        addressLabel.text = ""
        distanceLabel.text = ""
    }
    private lazy var nameLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .blackText
        return contentLabel
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .c999999
        return label
    }()
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .c999999
        return label
    }()
    
}

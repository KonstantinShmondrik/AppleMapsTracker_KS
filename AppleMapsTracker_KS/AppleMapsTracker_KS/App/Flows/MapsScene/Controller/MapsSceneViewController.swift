//
//  MapsSceneViewController.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 07.11.2022.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class MapsSceneViewController: UIViewController {
    
    // MARK: - Properties
    var onLogOut: (() -> Void)?
    
    lazy var viewModel = MapsSceneViewModel(locationManager: locationManager, realm: realm)
    
    private var mapSceneView: MapsSceneView {
        return self.view as! MapsSceneView
    }
    
    // MARK: - Services
    let locationManager = CLLocationManager()
    let realm = try! Realm()
    
    // MARK: - Properties
    var zoomValue: Double = 300
    var lastLocation: CLLocation?
    var currentRouteIndex: Int = 0 {
        didSet {
            if currentRouteIndex == 0 && viewModel.persistedRoutesCount == 2 {
                mapSceneView.previousRouteButton.isEnabled = false
                mapSceneView.nextRouteButton.isEnabled = true
                return
            }
            
            if currentRouteIndex == viewModel.persistedRoutesCount - 1 && viewModel.persistedRoutesCount == 2 {
                mapSceneView.previousRouteButton.isEnabled = true
                mapSceneView.nextRouteButton.isEnabled = false
            }
            
            if currentRouteIndex == 0 {
                mapSceneView.previousRouteButton.isEnabled = false
                return
            }
            
            if currentRouteIndex == viewModel.persistedRoutesCount - 1 {
                mapSceneView.nextRouteButton.isEnabled = false
                return
            }
            
            mapSceneView.previousRouteButton.isEnabled = true
            mapSceneView.nextRouteButton.isEnabled = true
        }
    }
    
    var isTracking: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                if self.isTracking {
                    self.mapSceneView.startStopTrackingButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
                    self.mapSceneView.startStopTrackingButton.tintColor = UIColor.systemRed
                } else {
                    self.mapSceneView.startStopTrackingButton.transform = .identity
                    self.mapSceneView.startStopTrackingButton.tintColor = UIColor.tintColor
                }
            }
        }
    }
    
    var isShowingPreviousRoute: Bool = false {
        didSet {
            mapSceneView.mapView.isScrollEnabled = isShowingPreviousRoute
            mapSceneView.mapView.showsUserLocation = !isShowingPreviousRoute
            
            UIView.animate(withDuration: 0.25) {
                if self.isShowingPreviousRoute {
                    self.mapSceneView.showPreviousRouteButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
                    self.mapSceneView.showPreviousRouteButton.tintColor = UIColor.systemRed
                    
                    if self.viewModel.persistedRoutesCount > 1 {
                        self.mapSceneView.nextRouteButton.alpha = 1
                        self.mapSceneView.previousRouteButton.alpha = 1
                    }
                    
                    self.view.layoutIfNeeded()
                } else {
                    self.mapSceneView.showPreviousRouteButton.transform = .identity
                    self.mapSceneView.showPreviousRouteButton.tintColor = UIColor.tintColor
                    self.mapSceneView.nextRouteButton.alpha = 0
                    self.mapSceneView.previousRouteButton.alpha = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Initialisers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        let view = MapsSceneView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        setNavigationBar()
        setupScene()
    }
    
    // MARK: - Methods
    private func setupScene() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        mapSceneView.mapView.delegate = self
        viewModel.configureLocationManager()
        mapSceneView.previousRouteButton.alpha = 0
        mapSceneView.nextRouteButton.alpha = 0
        mapSceneView.zoomInButton.alpha = 0
        mapSceneView.zoomOutButton.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.mapSceneView.zoomInButton.alpha = 1
            self.mapSceneView.zoomOutButton.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        if viewModel.persistedRoutesCount == 0 {
            mapSceneView.showPreviousRouteButton.alpha = 0
            mapSceneView.deletePersistedRoutesButton.alpha = 0
        }
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Текущее", style: .done, target: self, action: #selector(currentLocation))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(logOut))
    }
    
    // MARK: - Actions
    @objc func currentLocation (sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    @objc func logOut() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogOut?()
    }
}

// MARK: - MapsSceneViewProtocol
extension MapsSceneViewController: MapsSceneViewProtocol {
    func startStopTrackingButtonTapped() {
        isTracking.toggle()
        isShowingPreviousRoute = false
        removeAllOverlays()
        
        if isTracking {
            viewModel.startTracking()
        } else {
            viewModel.stopTracking()
        }
        
        if !isTracking && viewModel.persistedRoutesCount > 0 {
            
            UIView.animate(withDuration: 0.25) {
                self.mapSceneView.deletePersistedRoutesButton.alpha = 1
                self.mapSceneView.showPreviousRouteButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func showPreviousRouteButtonTapped() {
        currentRouteIndex = viewModel.persistedRoutesCount - 1
        mapSceneView.previousRouteButton.isEnabled = true
        
        if isTracking {
            self.yesNoAlert(title: "Прервать запись?", message: "Для отображения сохраненных маршрутов необходимо прервать запись текущего маршрута.") { _ in
                self.removeAllOverlays()
                self.isTracking = false
                self.isShowingPreviousRoute = true
                self.showRoute(self.viewModel.getPersistedRoutes(), index: self.currentRouteIndex)
            }
        } else {
            isShowingPreviousRoute.toggle()
        }
        
        if isShowingPreviousRoute {
            viewModel.loadRoutes()
        } else {
            removeAllOverlays()
        }
    }
    
    func zoomInButtonTapped() {
        
        guard zoomValue > 200 else { return }
        zoomValue -= 200
        
        if let lastLocation = lastLocation {
            mapSceneView.mapView.zoomToLocation(lastLocation, regionRadius: zoomValue)
        }
    }
    
    func zoomOutButtonTapped() {
        guard zoomValue < 100_000 else { return }
        
        zoomValue += 300
        
        if let lastLocation = lastLocation {
            mapSceneView.mapView.zoomToLocation(lastLocation, regionRadius: zoomValue)
        }
    }
    
    func previousRouteButtonTapped() {
        guard currentRouteIndex > 0, isShowingPreviousRoute else { return }
        
        currentRouteIndex -= 1
        showRoute(viewModel.getPersistedRoutes(), index: currentRouteIndex)
    }
    
    func nextRouteButtonTapped() {
        
        guard currentRouteIndex < viewModel.persistedRoutesCount - 1, isShowingPreviousRoute else { return }
        currentRouteIndex += 1
        showRoute(viewModel.getPersistedRoutes(), index: currentRouteIndex)
    }
    
    func deletePersistedRoutesButtonTapped() {
        self.yesNoAlert(title: "Удалить все маршруты?", message: "Вы действительно желаете удалить все сохраненные маршруты?") { _ in
            self.isTracking = false
            self.isShowingPreviousRoute = false
            self.removeAllOverlays()
            self.viewModel.deleteAllPersistedRoutes()
            
            UIView.animate(withDuration: 0.25) {
                self.mapSceneView.deletePersistedRoutesButton.alpha = 0
                self.mapSceneView.showPreviousRouteButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Additional extensions
extension MapsSceneViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if isShowingPreviousRoute == false {
                mapSceneView.mapView.zoomToLocation(location, regionRadius: zoomValue)
                lastLocation = location
            }
            
            if isTracking {
                viewModel.addCoordinate(location.coordinate)
                let myRoutePolyLine = MKPolyline(coordinates: viewModel.coordinates, count: viewModel.coordinates.count)
                mapSceneView.mapView.addOverlay(myRoutePolyLine)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapsSceneViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        
        polyLineRenderer.strokeColor = isShowingPreviousRoute ? .systemRed : .tintColor
        polyLineRenderer.lineWidth = 10
        
        return polyLineRenderer
    }
}

// MARK: - Implementation
extension MapsSceneViewController: MapsSceneViewDelegate {
    func removeAllOverlays() {
        mapSceneView.mapView.removeOverlays(mapSceneView.mapView.overlays)
    }
    
    func showRoute(_ routesArray: [UserPersistedRoute], index: Int = 0) {
        guard index < viewModel.persistedRoutesCount else { return }
        let currentRoute = routesArray[index]
        
        removeAllOverlays()
        
        var coordinatesArray: [CLLocationCoordinate2D] = []
        currentRoute.coordinates.forEach { coordinate in
            coordinatesArray.append(coordinate.coordinate)
        }
        
        isTracking = false
        
        let myRoutePolyLine = MKPolyline(coordinates: coordinatesArray, count: coordinatesArray.count)
        mapSceneView.mapView.addOverlay(myRoutePolyLine)
        
        if let middle = coordinatesArray.middle {
            lastLocation = CLLocation(latitude: middle.latitude, longitude: middle.longitude)
            mapSceneView.mapView.zoomToLocation(lastLocation!, regionRadius: zoomValue)
        }
        // --- точное позиционирование в границах polyline с отступами ---
        if let firstOverlay = mapSceneView.mapView.overlays.first {
            let rect = mapSceneView.mapView.overlays.reduce(firstOverlay.boundingMapRect, {$0.union($1.boundingMapRect)})
            mapSceneView.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
            zoomValue = mapSceneView.mapView.currentRadius()
        }
    }
    
    func showNoPersistedRoutesMessage() {
        quickAlert(message: "Нет сохраненных маршрутов.") { self.isShowingPreviousRoute = false }
    }
    
    func showStartTrackingMessage() {
        quickAlert(message: "Началась запись маршрута.")
    }
    
    func showStopTrackingMessage() {
        quickAlert(message: "Запись маршрута остановлена.")
    }
}

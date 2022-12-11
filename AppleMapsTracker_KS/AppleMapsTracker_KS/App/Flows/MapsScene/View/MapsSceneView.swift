//
//  MapsSceneView.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 07.11.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapsSceneViewProtocol: AnyObject {
    func startStopTrackingButtonTapped()
    func showPreviousRouteButtonTapped()
    func zoomInButtonTapped()
    func zoomOutButtonTapped()
    func previousRouteButtonTapped()
    func nextRouteButtonTapped()
    func deletePersistedRoutesButtonTapped()
    func selfieButtonTapped()
}

class MapsSceneView: UIView {
    
    weak var delegate: MapsSceneViewProtocol?
    var annotationIdentifier = "AnnotationIdentifier"
    
    // MARK: - Subviews
    private(set) lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var startStopTrackingButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(startStopTrackingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var showPreviousRouteButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showPreviousRouteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var zoomInButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var zoomOutButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "minus.magnifyingglass"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var previousRouteButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(previousRouteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var nextRouteButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(nextRouteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var deletePersistedRoutesButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(deletePersistedRoutesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var selfieButton: CircularButton = {
        let button = CircularButton()
        button.setImage(UIImage(systemName: "camera.aperture"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selfieButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        
        self.addSubview(self.mapView)
        self.addSubview(self.startStopTrackingButton)
        self.addSubview(self.showPreviousRouteButton)
        self.addSubview(self.zoomInButton)
        self.addSubview(self.zoomOutButton)
        self.addSubview(self.previousRouteButton)
        self.addSubview(self.nextRouteButton)
        self.addSubview(self.deletePersistedRoutesButton)
        self.addSubview(self.selfieButton)
        
        NSLayoutConstraint.activate([
            
            self.mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            self.mapView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor,constant: 0.0),
            self.mapView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor,constant: 0.0),
            self.mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: 0.0),
            
            self.deletePersistedRoutesButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.deletePersistedRoutesButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.deletePersistedRoutesButton.widthAnchor.constraint(equalToConstant: 50),
            self.deletePersistedRoutesButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.selfieButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.selfieButton.leftAnchor.constraint(equalTo: self.deletePersistedRoutesButton.rightAnchor, constant: 50),
            self.selfieButton.widthAnchor.constraint(equalToConstant: 50),
            self.selfieButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.showPreviousRouteButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.showPreviousRouteButton.widthAnchor.constraint(equalToConstant: 50),
            self.showPreviousRouteButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.previousRouteButton.centerYAnchor.constraint(equalTo: self.showPreviousRouteButton.centerYAnchor),
            self.previousRouteButton.centerXAnchor.constraint(equalTo: self.zoomInButton.centerXAnchor),
            self.previousRouteButton.widthAnchor.constraint(equalToConstant: 50),
            self.previousRouteButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.nextRouteButton.centerYAnchor.constraint(equalTo: self.showPreviousRouteButton.centerYAnchor),
            self.nextRouteButton.centerXAnchor.constraint(equalTo: self.zoomOutButton.centerXAnchor),
            self.nextRouteButton.widthAnchor.constraint(equalToConstant: 50),
            self.nextRouteButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.startStopTrackingButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.startStopTrackingButton.widthAnchor.constraint(equalToConstant: 100),
            self.startStopTrackingButton.heightAnchor.constraint(equalToConstant: 100),
            self.startStopTrackingButton.topAnchor.constraint(equalTo: self.showPreviousRouteButton.bottomAnchor, constant: 25),
            self.startStopTrackingButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            self.zoomInButton.centerYAnchor.constraint(equalTo: self.startStopTrackingButton.centerYAnchor),
            self.zoomInButton.rightAnchor.constraint(equalTo: startStopTrackingButton.leftAnchor, constant: -10),
            self.zoomInButton.widthAnchor.constraint(equalToConstant: 50),
            self.zoomInButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.zoomOutButton.centerYAnchor.constraint(equalTo: self.startStopTrackingButton.centerYAnchor),
            self.zoomOutButton.leftAnchor.constraint(equalTo: startStopTrackingButton.rightAnchor, constant: 10),
            self.zoomOutButton.widthAnchor.constraint(equalToConstant: 50),
            self.zoomOutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    @objc func startStopTrackingButtonTapped() {
        self.delegate?.startStopTrackingButtonTapped()
    }
    
    @objc func showPreviousRouteButtonTapped() {
        self.delegate?.showPreviousRouteButtonTapped()
    }
    
    @objc func zoomInButtonTapped() {
        self.delegate?.zoomInButtonTapped()
    }
    
    @objc func zoomOutButtonTapped() {
        self.delegate?.zoomOutButtonTapped()
        
    }
    
    @objc func previousRouteButtonTapped() {
        self.delegate?.previousRouteButtonTapped()
        
    }
    
    @objc func nextRouteButtonTapped() {
        self.delegate?.nextRouteButtonTapped()
    }
    
    @objc func deletePersistedRoutesButtonTapped() {
        self.delegate?.deletePersistedRoutesButtonTapped()
    }
    
    @objc func selfieButtonTapped() {
        self.delegate?.selfieButtonTapped()
    }
}



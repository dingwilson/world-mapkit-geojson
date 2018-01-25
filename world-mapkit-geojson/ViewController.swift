//
//  ViewController.swift
//  world-mapkit-geojson
//
//  Created by Wilson Ding on 1/24/18.
//  Copyright © 2018 Wilson Ding. All rights reserved.
//

import UIKit
import MapKit
import GEOSwift

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self

        setupGeoJSON(fileName: "countries")
    }

    // Takes in file name of geojson file, plots setupGeoJSON
    func setupGeoJSON(fileName: String) {
        var overlays: [MKOverlay] = []

        guard let geoJSONURL = Bundle.main.url(forResource: fileName, withExtension: ".geojson"),
            let featuresO = try? Features.fromGeoJSON(geoJSONURL),
            let features = featuresO
        else {
            print("Could not get features from geojson")
            return
        }

        for feature in features {
            guard let geometries = feature.geometries else {
                print("Could not get geometries from feature")
                return
            }

            for subGeometry in geometries {
                guard let overlay = subGeometry.mapShape() as? MKOverlay else {
                    print("Could not create overlay from geometries")
                    break
                }

                overlays.append(overlay)
            }
        }

        self.mapView.addOverlays(overlays)
    }

}

// Mark: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let overlay as MKPolygon:
            let polygonRenderer = MKPolygonRenderer(polygon: overlay)
            polygonRenderer.lineWidth = 0.5
            polygonRenderer.fillColor = UIColor.black.withAlphaComponent(0.2)
            polygonRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.2)
            return polygonRenderer
        default: return MKOverlayRenderer() // empty renderer.
        }
    }
}

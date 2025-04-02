//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Nguyen, Sydney on 3/31/25.
//

import SwiftUI
import MapKit

let data = [
    Item(name: "Magick Matcha", neighborhood: "South Congress", desc: "Magick Matcha, in South Congress, serves vibrant matcha lattes, espresso drinks, and THC/CBD-infused options (21+). Founded in 2021, this woman-owned shop offers a magical, community-driven experience.", lat: 30.24843152394469, long: -97.75038576017973, imageName: "magick"),
    Item(name: "Merit Coffee", neighborhood: "Rainey Street", desc: "Merit Coffee, established in 2009, serves high-quality coffee and drinks like their renowned strawberry matcha. Sourced globally, their ceremonial grade matcha and fresh strawberries will leave you needing more.", lat: 30.295132110827765, long: -97.75523339134197, imageName: "merit"),
    Item(name: "Two Hands", neighborhood: "South Congress", desc: "Two Hands Hospitality offers Australian-inspired food, coffee, and cocktails with a focus on health and community. Their matcha tastes like a hug in a cup, no modifications needed.", lat: 30.253662227070922, long: -97.74783405833296, imageName: "twohands"),
    Item(name: "Houndstooth", neighborhood: "North Loop", desc: "Houndstooth Coffee is a place for your daily rhythm, offering expertly crafted coffee and drinks like their delicious matcha. Inspired by the regional pride of Scottish plaids, grab a matcha latte and enjoy the shop's ambiance.", lat: 30.312899501139302, long: -97.74040602042808, imageName: "houndstooth"),
    Item(name: "Desnudo", neighborhood: "East Austin", desc: "Going beyond just selling matcha and coffee, they focus on fair partnerships with small producers. They ensure farmers receive fair prices, promote education, and encourage sustainable practices. High-quality matchas accompanied by a cute aesthetic.", lat: 30.264855546643982, long: -97.71315638459537, imageName: "desnundo")
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.295190, longitude: -97.726220), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    @State private var selectedNeighborhood: String = "All" // Default filter
    let neighborhoods = ["All", "South Congress", "Rainey Street", "North Loop", "East Austin"]
    
    var filteredData: [Item] {
        if selectedNeighborhood == "All" {
            return data
        } else {
            return data.filter { $0.neighborhood == selectedNeighborhood }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Dropdown filter for neighborhoods
                HStack {
                    Spacer() // Align to the right
                    Menu {
                        ForEach(neighborhoods, id: \.self) { neighborhood in
                            Button(action: {
                                selectedNeighborhood = neighborhood
                            }) {
                                Text(neighborhood)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedNeighborhood)
                                .font(.headline)
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(5)  // Make the dropdown slimmer
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: 150)  // Slim filter width
                }
                
                // List of filtered items
                List(filteredData, id: \.name) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.neighborhood)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                
                // Map
                Map(coordinateRegion: $region, annotationItems: filteredData) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 300)  // Adjust the map height
                .padding(.bottom, -30)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Matcha in Austin")
        }
    }
}

struct DetailView: View {
    @State private var region: MKCoordinateRegion
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
    }
    
    let item: Item
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)
            Text("Neighborhood: \(item.neighborhood)")
                .font(.subheadline)
            Text("Description: \(item.desc)")
                .font(.subheadline)
                .padding(10)
            Map(coordinateRegion: $region, annotationItems: [item]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .overlay(
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: true, vertical: false)
                                .offset(y: 25)
                        )
                }
            }
            .frame(height: 200)
            .padding(.bottom, -30)
        }
        .navigationTitle(item.name)
        Spacer()
    }
}

#Preview {
    ContentView()
}

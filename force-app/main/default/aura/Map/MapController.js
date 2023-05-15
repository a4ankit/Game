({
    jsLoaded: function(component, event, helper) {
        console.log('leaflet loaded');
        var map = L.map('map').setView([51.505, -0.09], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        
        component.set("v.map", map);

        
        L.marker([51.5, -0.09]).addTo(map)
        .bindPopup('A custom marker')
        .openPopup();  
        
        var popup = L.popup();
        
        function onMapClick(e) {
            popup
            .setLatLng(e.latlng)
            .setContent("User clicked the map at " + e.latlng.toString())
            .openOn(map);
        }
        
        map.on('click', onMapClick);
        
        var circle = L.circle([51.508, -0.11], {
            color: 'red',
            fillColor: '#f03',
            fillOpacity: 0.5,
            radius: 500
        }).addTo(map);
        
        var polygon = L.polygon([
            [51.509, -0.08],
            [51.503, -0.06],
            [51.51, -0.047]
        ]).addTo(map);
    },
    mapboxLoaded : function(component, event, helper){
        console.log('mapbox loaded');
        mapboxgl.accessToken = 'pk.eyJ1IjoiYTRhbmtpdCIsImEiOiJjanY3cjcyMXMwNHA4M3lyeGh0NXg0eTJiIn0.AYK_UhcQDWMPumFChsMGCQ';
        var map2 = new mapboxgl.Map({
            container: 'map2',
            zoom: 9,
            center: [137.9150899566626, 36.25956997955441],
            style: 'mapbox://styles/mapbox/satellite-v9'
        });
        console.log('map2++'+map2);
        component.set("v.map2", map2);
    }
})
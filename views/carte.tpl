<!DOCTYPE html>
<html>
<head>
  <title>Quick SLPK Server - viewer : {{slpk}}</title>
  <style>
    html,
    body,
    #viewDiv {
      padding: 0;
      margin: 0;
      height: 100%;
      width: 100%;
    }
  </style>

  <link rel="stylesheet" href="https://js.arcgis.com/4.6/esri/css/main.css">
  <script src="https://js.arcgis.com/4.9/"></script>

  <script>
	var measureWidget, view;
    require([
      "esri/Map",
      "esri/views/SceneView",
      "esri/layers/SceneLayer",
	  "esri/widgets/DirectLineMeasurement3D",
	  "esri/widgets/Legend",
	  "esri/layers/IntegratedMeshLayer",
	  "dojo/request",
      "dojo/domReady!"
    ], function(Map, SceneView, SceneLayer, DirectLineMeasurement3D,Legend,IntegratedMeshLayer,request) {

      // Create Map
      var map = new Map({
        basemap: "topo",
        ground: "world-elevation"
      });

      // Create the SceneView
      view = new SceneView({
        container: "viewDiv",
        map: map,
      });

      // Create SceneLayer and add to the map
	  request("{{url}}",{handleAs: "json"}).then(function(json){
		  if(json.layerType=="IntegratedMesh"){
			  var layer = new IntegratedMeshLayer({
				url:"{{url}}"
			  });
		  }else{
			  var layer = new SceneLayer({
				url:"{{url}}"
			  });
		  }
		  map.add(layer);
		  
		  // Automatic zoom to layer extent
		layer.when(function(){
		  view.goTo(layer.fullExtent);
		});
	  });
	
	//3d measure
	  dojo.connect(dojo.byId("startmeasure"),"onclick", function(){
			// initialize widget
			measureWidget = new DirectLineMeasurement3D({
				view: view,
				});
			view.ui.add(measureWidget, "top-right");
			});
	  dojo.connect(dojo.byId("stopmeasure"),"onclick", function(){
			view.ui.empty("top-right");
			measureWidget.destroy();
			});
	
	//legend
        view.when(function() {
          // when the resources in the MapView have loaded.
          var legend = new Legend({
            view: view,
            layerInfos: [{
              layer: layer,
              title: "{{slpk}}"
            }]
          });

          // Add widget to the bottom right corner of the view
          view.ui.add(legend, "bottom-right");
        });
    });
  </script>
</head>

<body>
 <button id="startmeasure" type="button">Start 3D Measure</button>
 <button id="stopmeasure" type="button">Stop 3D Measure</button>
  <div id="viewDiv"></div>
</body>
</html>

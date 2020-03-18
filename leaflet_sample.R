# Define inputs
selectInput('metro_name', label = 'Select a metropolitan area', choices = lookup, selected = 19100L)



sliderInput('span', label = 'Span Parameter', min = 0.1, max = 0.9, value = 0.3, 
            step = 0.1)
# Set up data download
data_for_dl <- reactive({
  
  dat <- select(metro()@data, GEOID, state, county, white, black, hispanic, asian, total, 
                entropy, distmeters = distance, distmiles)
  
})
output$downloadCSV <- downloadHandler(
  filename = 'data.csv', 
  content = function(file) {
    write_csv(data_for_dl(), file)
  }
)
downloadLink('downloadCSV', label = 'Download CSV for active metro (2010)')


###################################################################################################
###################################################################################################
###################################################################################################



### Map of diversity scores

# Draw the map without selected tracts
output$map <- renderLeaflet({
  
  pal <- colorNumeric('Reds', NULL)
  
  map <- leaflet(metro()) %>%
    addProviderTiles('CartoDB.Positron') %>%
    clearShapes() %>%
    addPolygons(stroke = FALSE, smoothFactor = 0, 
                fillColor = ~pal(entropy), fillOpacity = 0.7, 
                layerId = ~GEOID) %>%
    addLegend(position = 'bottomright', pal = pal, 
              values = metro()$entropy, title = 'Score')
  
  map
  
})

# Click event for the map (will use to generate chart)
click_tract <- eventReactive(input$map_shape_click, {
  x <- input$map_shape_click
  y <- x$id
  return(y)
})

# Drag event for the scatterplot; will grab tractids of selected points
sub <- reactive({
  eventdata <- event_data('plotly_selected', source = 'source')
  
  if (is.null(eventdata)) {
    
    return(NULL) # do nothing
    
  } else {
    
    tracts <- eventdata[['key']]
    
    if (length(tracts) == 0) {
      
      tracts <- 'abcdefg' # a hack but it's working - set to something that can't be selected
      
    }
    
    if (!(tracts %in% metro()$tractid)) {
      
      return(NULL) # if there is not a match, do nothing as well
      
    } else {
      
      # Give back a sp data frame of the selected tracts
      sub <- metro()[metro()$tractid %in% tracts, ]
      return(sub)
      
    }
    
  }
})

observe({
  req(sub()) # Do this if sub() is not null
  proxy <- leafletProxy('map')
  
  # Clear old selection on map, and add new selection
  proxy %>%
    clearGroup(group = 'sub') %>%
    addPolygons(data = sub(), fill = FALSE, color = '#FFFF00',
                opacity = 1, group = 'sub') %>%
    fitBounds(lng1 = bbox(sub())[1],
              lat1 = bbox(sub())[2],
              lng2 = bbox(sub())[3],
              lat2 = bbox(sub())[4])
})

observe({
  
  req(click_tract()) # do this if click_tract() is not null
  
  # Add the clicked tract to the map in aqua, and remove when a new one is clicked
  map <- leafletProxy('map') %>%
    removeShape('htract') %>%
    addPolygons(data = full_tracts[full_tracts$GEOID == click_tract(), ], fill = FALSE,
                color = '#00FFFF', opacity = 1, layerId = 'htract')
})
tract_data <- reactive({
  
  # Fetch data for the clicked tract
  return(metro()@data[metro()@data$GEOID == click_tract(), ])
})
leafletOutput('map')  
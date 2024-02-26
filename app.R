library(shiny)
library(leaflet)


ui = fluidPage(
  # numericInput('n', 'Number of obs', 100),
  # leafletOutput('plot')
  leafletOutput("plot",height = "100vh")
)

server = function(input, output) {
  output$plot <- renderLeaflet({ 
    # temp = "tiles/{z}/{x}/{-y}.png"
    # temp = "WDPA_50_tiles/{z}/{x}/{-y}.png"
    # temp = "wpda50/{z}/{x}/{-y}.png"
    # temp = "Underprotected/{z}/{x}/{-y}.png"
    # temp = "https://wajahat16079.github.io/checkRastersTiles/www/wpda50/{z}/{x}/{y}.png"
    # temp = "https://github.com/wajahat16079/checkRastersTiles/www/wpda50/{z}/{x}/{y}.png"
    temp = "https://raw.githubusercontent.com/wajahat16079/checkRastersTiles/main/www/wpda50/{z}/{x}/{-y}.png"
    # an fans 
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldTopoMap, group = "base") %>%
      # clearGroup("overlay") %>%
      addTiles(urlTemplate = temp,
               group = 'overlay',
               tileOptions(opacity = 0.7))
    })
}

shinyApp(ui = ui, server = server)
library(tiler)
library(raster)
library(leaflet)
library(mapview)
tiler_options()

tiler_options(osgeo4w = "C:/OSGeo4W/OSGeo4W.bat")
getwd()
tiler_options()

x <- system.file("maps/map_wgs84.tif", package = "tiler")
x <- system.file("maps/map_albers.tif", package = "tiler")
tile(x, "tiles", 0)
vignette(package = "tiler")

pal <- colorRampPalette(c("darkblue", "lightblue"))(20)
nodata <- "tomato"
tile(x, "tiles", "0-3", col = pal, colNA = nodata)

tile(x, "tiles", "0-3")

str_name<-'WDPA_50Rich_8Bit.tif' 
x <- system.file()

tile_layer <- raster(str_name)
# map <- system.file(str_name, package = "tiler")
# map <- 'WDPA_50Rich_8Bit.tif' 
map <- 'Underprotected_8Bit.tif' 
tile_dir = "tiles"
crs <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs +towgs84=0,0,0"
# tile(map, tile_dir, "0-3", crs)

tile(str_name, "WDPA_50_tiles", "0-3",crs)
r <- brick(str_name)
(r <- raster(map))

polys1 = rasterToPolygons(r)

r@data

#> class      : RasterLayer 
#> dimensions : 32, 71, 2272  (nrow, ncol, ncell)
#> resolution : 0.8333333, 0.8333333  (x, y)
#> extent     : -125.0208, -65.85417, 23.27083, 49.9375  (xmin, xmax, ymin, ymax)
#> crs        : +proj=longlat +datum=WGS84 +no_defs 
#> source     : map_wgs84.tif 
#> names      : map_wgs84 
#> values     : -0.7205295, 5.545086  (min, max)
par(mar=c(1,1,1,1))
plot(r)

tile(map, tile_dir, "0-3")
#> Coloring raster...
#> Preparing for tiling...
#> Creating tiles. Please wait...
#> Creating tile viewer...
#> Complete.

list.files(tile_dir)
temp = "www/tiles/{z}/{x}/{-y}.png"
temp = "tiles/{z}/{x}/{-y}.png"
leaflet() %>%
  clearGroup("overlay") %>%
  addTiles(urlTemplate = temp,
           group = 'overlay',
           tileOptions(opacity = 0.7))

leaflet(
  options = leafletOptions(
    # crs = leafletCRS("L.CRS.Simple"),
    minZoom = 0, maxZoom = 3, attributionControl = FALSE), width = "100%") %>%
  addProviderTiles(providers$Esri.WorldTopoMap, group = "base") %>%
  addTiles(temp) 

# %>% setView(71, -60, 3)


getwd()

plot(r)

# map <- system.file("maps/map_wgs84.tif", package = "tiler")
pal <- colorRampPalette(c("darkblue", "lightblue"))(20)
nodata <- "tomato"
tile(str_name, "tiles", "0-3", col = pal, colNA = nodata)
list.files("tiles")


m <- leaflet() %>%
  setView(lng = mean(extent(tile_layer)[1:2]), lat = mean(extent(tile_layer)[3:4]), zoom = 10) %>%
  addTiles() %>%
  addRasterImage(tile_layer, maxBytes = 50000000)

m
imported_raster=raster(str_name)

str(imported_raster)
library(htmlwidgets)
library(raster)
library(leaflet)

# PATHS TO INPUT / OUTPUT FILES
projectPath = "/home/kreis/git/geotiff/"
#imgPath = paste(projectPath,"data/cea.tif", sep = "")
#imgPath = paste(projectPath,"data/o41078a1.tif", sep = "") # bigger than standard max size (15431804 bytes is greater than maximum 4194304 bytes)
# imgPath = paste(projectPath,"data/SP27GTIF.TIF", sep = "")
imgPath = 'WDPA_50Rich_8Bit.tif' 

#Load
library("jpeg")
library("tiff")

img <- readTIFF('WDPA_50Rich_8Bit.tif', native=TRUE)
writeJPEG(img, target = "Converted.jpeg", quality = 1)

# Load Required Packages
library(raster)
library(gdalUtils)
library(png)

# Load Required Packages
library(raster)
# devtools:::install_github("gearslaboratory/gdalUtils")
library(gdalUtils)
library(png)

# Define input and output paths
input_tif <- "input.tif"
output_dir <- "tiles"

# Convert TIF to PNG
output_png <- file.path(tempdir(), "output.png")
gdal_translate(input_tif, output_png, of = "PNG")

# Read PNG Image
png_image <- readPNG(output_png)

# Define tile parameters
tile_width <- 256
tile_height <- 256

# Create output directory if it does not exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Loop through and create tiles
for (i in 0:floor(dim(png_image)[2] / tile_width)) {
  for (j in 0:floor(dim(png_image)[1] / tile_height)) {
    x_min <- i * tile_width + 1
    x_max <- min((i + 1) * tile_width, dim(png_image)[2])
    y_min <- j * tile_height + 1
    y_max <- min((j + 1) * tile_height, dim(png_image)[1])
    
    tile <- png_image[y_min:y_max, x_min:x_max, ]
    filename <- file.path(output_dir, paste0(j, "/", i, "/", j, "-", i, ".png"))
    dir.create(dirname(filename), recursive = TRUE, showWarnings = FALSE)
    writePNG(tile, filename)
  }
}

# Clean up temporary PNG file
file.remove(output_png)

print("Tiles generated successfully!")

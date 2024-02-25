library(tiler)
library(raster)
library(leaflet)
library(mapview)

tiler_options(osgeo4w = "C:/OSGeo4W/OSGeo4W.bat")

tiler_options()

colorList <- c('#1C6FF8', '#27BBE0', '#31DB92', '#1BF118', '#9BFA24', '#FEF720' )

outDir = "www/Underprotected"

# map <- 'WDPA_50Rich_8Bit.tif' 
map <- 'Underprotected_8Bit.tif' 

crs <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs +towgs84=0,0,0"

crs1 = "+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +datum=WGS84 +units=m +no_defs"
crs2 = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

(r <- raster(map))

# tile(map, outDir,"0-3",crs, col = colorList)
tile(map, outDir,"0-10",crs2,col = colorList)

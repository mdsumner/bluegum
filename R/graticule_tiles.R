#' Graticule tiles
#'
#' Triangles, 2 per tile-face.
#'
#' The hull form can be used to close a mesh with the convex hull method that is
#' the Delaunay triangulation of points on a sphere. If the full sphere is not
#' included then a segment can be created. Otherwise, if `hull = FALSE` then an
#' actual Delaunay triangulation mesh is created.
#'
#' We use the termniology longitude (phi, azimuth) and latitude (theta,
#' elevation) in the range -180, 180 degrees and -90, 90 degrees. Longitude
#' range is defined by xlim, latitude range by ylim.
#'
#' We use the Geocentric XYZ projection by default, on WGS84. For spherical
#' forms use 'crs = "+proj=sphere +a=1' for a sphere of radius 1.
#' @param n number of tile faces in x and y directions (give 2-elements for
#'   independent x, y)
#' @param xlim longitude range (phi, azimuth)
#' @param ylim latitude range (theta, elevation)
#' @param hull if `TRUE` use the convex hull (assuming full sphere)
#' @export
#' @return mesh3d object
#' @examples
#' library(rgl)
#' x <- tri_graticule(n = c(12, 9))
#' clear3d()
#' shade3d(x)
#' aspect3d(1, 1, 1)
#' rglwidget()
#'
#' library(rgl)
#' qx <- quad_graticule(n = c(12, 9))
#' clear3d()
#' shade3d(qx)
#' aspect3d(1, 1, 1)
#' rglwidget()
tri_graticule <- function(n = 12, xlim = c(-180, 180), ylim = c(-90, 90), hull = FALSE,
                          crs = "+proj=geocent +datum=WGS84") {
  xlim <- sort(xlim)
  ylim <- sort(ylim)
  convh_ok <- all(c(xlim, ylim) == c(-180, 180, -90, 90))
  ## but,
  if (hull) conv_ok <- TRUE
  n <- rep(n, length.out = 2L)
  span <- c(diff(xlim), diff(ylim))
  grain <- span / n
  (lon <- seq(xlim[1L], by = grain[1L], length.out = n[1L]))
  lat <- seq(ylim[1L], ylim[2L], by = grain[2L])
  p0 <- rbind(cbind(x = xlim[1L], y = 90),
            do.call(rbind, lapply(lat[-c(1, length(lat))], function(i) cbind(lon, i))),
            cbind(xlim[1L], -90))
  p0 <- cbind(p0, z = 0)
  pts <- reproj::reproj(p0,
                      source = 4326, target = "+proj=geocent")

  if (convh_ok) {
    #print('convh')
    triangles <- geometry::convhulln(pts[,1:3])
  } else {
    #print('delone')
    triangles <- geometry::delaunayn(p0[,1:2])
  }

  ord <- order(p0[t(triangles), 1], p0[t(triangles), 2])
  rgl::tmesh3d(rbind(t(pts), h = 1), t(triangles),
               material = list(color = viridis::viridis(nrow(pts)), meshColor = "vertices"))
}

#' @name tri_graticule
#' @export
quad_graticule <- function(n = 12, xlim = c(-180, 180), ylim = c(-90, 90), hull = FALSE,
                           crs = "+proj=geocent +datum=WGS84") {
  if (hull) warning("hull argument is ignored for quad type, use tri_graticule() instead")
  xlim <- sort(xlim)
  ylim <- sort(ylim)
  n <- rep(n, length.out = 2L)
  out <- reproj::reproj(quadmesh::quadmesh(raster::raster(raster::extent(xlim, ylim), nrows = n[1L], ncols = n[2L],
                                    crs = "+init=epsg:4326")), target = crs)
  class(out) <- c("mesh3d", "shape3d")  ## drop quadmesh part
  out$raster_metadata <- NULL
  out$primitivetype <- NULL
  out
}


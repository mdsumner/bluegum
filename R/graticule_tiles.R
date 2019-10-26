#' Graticule tiles
#'
#' Triangles, 2 per tile-face.
#'
#' The hull form can be used to close a mesh with the convex hull method that is
#' the Delaunay triangulation of points on a sphere. If the full sphere is not
#' included then a segment can be created. Otherwise, if `hull = FALSE` then an
#' actual Delaunay triangulation mesh is created.
#'
#' [tri_graticule()] uses Delaunay triangulation via convex hull or directly,
#' [quad_graticule()] creates a quadmesh and uses that, there's no hull method.
#' We use the termniology longitude (phi, azimuth) and latitude (theta,
#' elevation) in the range -180, 180 degrees and -90, 90 degrees. Longitude
#' range is defined by xlim, latitude range by ylim.
#'
#' We use the Geocentric XYZ projection by default, on WGS84. For spherical
#' forms use 'crs = "+proj=sphere +a=1' for a sphere of radius 1.
#'
#' @param n number of tile faces in x and y directions (give 2-elements for
#'   independent x, y)
#' @param xlim longitude range (phi, azimuth)
#' @param ylim latitude range (theta, elevation)
#' @param hull if `TRUE` use the convex hull (assuming full sphere)
#' @param sub depth of subdivision to apply, no subdivision by default ('sub = 0')
#' @param crs projection of globe in PROJ.4 form
#'
#' @export
#' @return mesh3d object
#' @examples
#' library(rgl)
#' x <- tri_graticule(n = c(12, 9))
#' clear3d()
#' shade3d(x)
#' aspect3d(1, 1, 1)
#' #rglwidget()
#'
#' library(rgl)
#' qx <- quad_graticule(n = c(12, 9))
#' clear3d()
#' shade3d(qx)
#' aspect3d(1, 1, 1)
#' #rglwidget()
tri_graticule <- function(n = 12, xlim = c(-180, 180), ylim = c(-90, 90), hull = FALSE,
                          crs = "+proj=geocent +datum=WGS84", sub = 0) {

  #n = 12; xlim = c(-180, 180); ylim = c(-90, 90); hull = FALSE; crs = "+proj=geocent +datum=WGS84"; sub = 0
  xlim <- sort(xlim)
  ylim <- sort(ylim)
  chull_ok <- all(c(xlim, ylim) == c(-180, 180, -90, 90))
  ## but,
  if (hull) chull_ok <- TRUE
  n <- rep(n, length.out = 2L)
  span <- c(diff(xlim), diff(ylim))
  grain <- span / n
  (lon <- seq(xlim[1L], by = grain[1L], length.out = n[1L]))
  lat <- seq(ylim[1L], ylim[2L], by = grain[2L])

  p0 <- rbind(cbind(x = xlim[1L], y = ylim[2L]),
            do.call(rbind, lapply(lat[-c(1, length(lat))], function(i) cbind(lon, i))),
            cbind(xlim[1L], ylim[1L]))
  p0 <- cbind(p0, z = 0)
  pts <- reproj::reproj(p0,
                      source = "+proj=longlat +datum=WGS84", target = crs)

  if (chull_ok) {
    #print('chull')
    triangles <- geometry::convhulln(pts[,1:3])
  } else {
    #print('delone')
    triangles <- geometry::delaunayn(p0[,1:2])
  }

  ord <- order(p0[t(triangles), 1], p0[t(triangles), 2])
  mesh <- rgl::tmesh3d(rbind(t(pts), h = 1), t(triangles),
               material = list(color = viridis::viridis(nrow(pts)), meshColor = "vertices"))
  if (sub > 0) {
    mesh <- rgl::subdivision3d(mesh)
    mesh$material$color <- colourvalues::colour_values(mesh$vb[2L, ])
  }
  mesh
}

#' @name tri_graticule
#' @export
quad_graticule <- function(n = 12, xlim = c(-180, 180), ylim = c(-90, 90), hull = FALSE,
                           crs = "+proj=geocent +datum=WGS84", sub = 0) {
  if (hull) warning("hull argument is ignored for quad type, use tri_graticule() instead")
  xlim <- sort(xlim)
  ylim <- sort(ylim)
  n <- rep(n, length.out = 2L)
  r0 <- raster::setValues(raster::raster(raster::extent(xlim, ylim), nrows = n[1L], ncols = n[2L],
                       crs = "+proj=longlat +datum=WGS84"), 0)
  out <- suppressWarnings(reproj::reproj(quadmesh::quadmesh(r0), target = crs))
  #class(out) <- c("mesh3d", "shape3d")  ## drop quadmesh part
  ord <-  rev(seq_len(ncol(out$ib)))  ## reverse raster order
  ## we need the coordinate and index creation out of quadmesh, and use qmesh3d() so we can
  ## control the meshColor
  out$material <- list(color = viridis::viridis(ncol(out$ib))[ord])
  #out$raster_metadata <- NULL
  out$primitivetype <- NULL
  out$meshColor <- "faces"
  if (sub > 0) out <- rgl::subdivision3d(out, depth = sub)
  out
}


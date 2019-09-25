
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bluegum

<!-- badges: start -->

<!-- badges: end -->

The goal of bluegum is to get the simplest mesh creation for the Rglobal
project and outline the space of tools that already exist.

Currently this stuff is scattered over a mess of my projects, gris,
anglr, silicate, quadmesh, and it’s time to outline the bare essentials
and just how powerful rgl (and some key friends) already are.

WIP

## ways to generate a globe mesh

### 1\. convex hull in 3D is Delaunay surface

For use with arbitrary locations on the sphere.

``` r
pts <- geosphere::randomCoordinates(500)
xyz <- proj4::ptransform(pts * pi/180, "+proj=longlat", 
                                       "+proj=geocent")
mv <- geometry::convhulln(xyz)
library(rgl)
clear3d()
lines3d(xyz[t(cbind(mv, NA)), ], col = "firebrick", lwd = 2)
triangles3d(xyz[t(mv), ], alpha = 0.4)
rglwidget()
```

## 2\. icosa

See Agafonkin for a parallel tool in JS:
<https://twitter.com/mourner/status/1176159651953594370>

``` r
library(icosa)
g <- icosa::trigrid(8)
library(rgl)
clear3d()
## note that we cannot index by name and use NA, hence match() here
lines3d(g@vertices[match(t(cbind(g@edges, NA) ), rownames(g@vertices)), ])
rglwidget()
```

## 3\. quadmesh+reproj direct from a raster

## 4\. terrain relief on mesh (trivial)

## 5\. image textures - mesh3d format (two-step indexing to 0,1)

-----

Please note that the ‘bluegum’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
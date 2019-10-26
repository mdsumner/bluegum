
<!-- README.md is generated from README.Rmd. Please edit that file -->

## bluegum

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/mdsumner/bluegum.svg?branch=master)](https://travis-ci.org/mdsumner/bluegum)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/mdsumner/bluegum?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/bluegum)
[![Codecov test
coverage](https://codecov.io/gh/mdsumner/bluegum/branch/master/graph/badge.svg)](https://codecov.io/gh/mdsumner/bluegum?branch=master)
<!-- badges: end -->

The goal of bluegum is to get the simplest mesh creation for the
R-global project and outline the space of tools that already exist.

Currently this stuff is scattered over a mess of my projects, gris,
anglr, silicate, quadmesh, and it’s time to outline the bare essentials
and just how powerful rgl (and some key friends) already are.

WIP

### Scope

We will limit to visualizations that use a geocentric projection of the
Earth’s surface - i.e. a globe. Luckily this does allow us to visit a
lot of options.

#### convex hull in 3D is Delaunay surface

For use with arbitrary locations on the sphere. It really does need to
be spherical otherwise the hull wraps around the inside of the sliced
sphere.

``` r
library(bluegum)
hull <- tri_graticule(hull = TRUE)
library(rgl)
#clear3d();
#plot3d(hull, specular = "black")
#rglwidget()
```

Make it more detailed so that individual faces aren’t so visible.

``` r
hull <- tri_graticule(n = 60 * c(1, 1/2), hull = TRUE)
library(rgl)
clear3d()
plot3d(hull, specular = grey(0.05))
rglwidget()
```

But, we can’t ask for a partial sphere when it’s a hull, because the
hull has to wrap around (well, you might want this but it’s not faceted
on those internal sides).

``` r
hull <- tri_graticule(xlim = c(100, 150),  hull = TRUE)
clear3d()
plot3d(hull, specular = "black")
rglwidget()
```

### direct creation of delaunay hull

If we only want a sector we need to use a triangulation tool directly.

``` r
hull <- tri_graticule(xlim = c(100, 150),  hull = FALSE)
clear3d()
plot3d(hull, specular = "black")
rglwidget()
```

We probably can’t tell the difference, hull or otherwise.

``` r
library(bluegum)
hull <- tri_graticule(hull =FALSE)
library(rgl)
clear3d();
plot3d(hull, alpha = 0.5, specular = "black")
rglwidget()
```

### 2\. icosa

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

### 3\. quadmesh+reproj direct from a raster

### 4\. terrain relief on mesh (trivial)

### 5\. image textures - mesh3d format (two-step indexing to 0,1)

-----

Please note that the ‘bluegum’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.

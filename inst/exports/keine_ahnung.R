
## no idea how
hull <- tri_graticule(n = 24 * c(1, 1/2))
library(rgl)

clear3d()
plot3d(addNormals(hull), specular = grey(0.05))
rglwidget()

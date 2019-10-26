test_that("tri_graticule works", {
  mesh <- tri_graticule() %>% expect_s3_class( "mesh3d")

  expect_s3_class(tri_graticule(xlim = c(10, 20)), "mesh3d")
  expect_s3_class(tri_graticule(ylim = c(-80, -70)), "mesh3d")
  expect_s3_class(tri_graticule(xlim = c(100, 150), ylim = c(-80, -70)), "mesh3d")

  expect_s3_class(tri_graticule(hull = TRUE), "mesh3d")
  expect_s3_class(tri_graticule(xlim = c(10, 20),hull = TRUE), "mesh3d")
  expect_s3_class(tri_graticule(ylim = c(-80, -70),hull = TRUE), "mesh3d")
  expect_s3_class(tri_graticule(xlim = c(100, 150), ylim = c(-80, -70),hull = TRUE), "mesh3d")


  expect_s3_class(tri_graticule(hull = TRUE, sub = 1), "mesh3d")

  expect_s3_class(tri_graticule(ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d")

  mesh2 <- tri_graticule(n = 15) %>% expect_s3_class( "mesh3d")
  expect_true(ncol(mesh$vb) < ncol(mesh2$vb))

  expect_s3_class(tri_graticule(n = 20, ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d")


})



test_that("quad_graticule works", {
  mesh <- quad_graticule() %>% expect_s3_class( "mesh3d")

  expect_s3_class(quad_graticule(xlim = c(10, 20)), "mesh3d")
  expect_s3_class(quad_graticule(ylim = c(-80, -70)), "mesh3d")
  expect_s3_class(quad_graticule(xlim = c(100, 150), ylim = c(-80, -70)), "mesh3d")

  expect_warning(expect_s3_class(quad_graticule(hull = TRUE), "mesh3d"))
                 expect_warning(expect_s3_class(quad_graticule(xlim = c(10, 20),hull = TRUE), "mesh3d"))
  expect_warning(expect_s3_class(quad_graticule(ylim = c(-80, -70),hull = TRUE), "mesh3d"))
  expect_warning(expect_s3_class(quad_graticule(xlim = c(100, 150), ylim = c(-80, -70),hull = TRUE), "mesh3d"))


  expect_warning(expect_s3_class(quad_graticule(hull = TRUE, sub = 1), "mesh3d"))

  expect_warning(expect_s3_class(quad_graticule(ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d"))

  mesh2 <- quad_graticule(n = 15) %>% expect_s3_class( "mesh3d")
  expect_true(ncol(mesh$vb) < ncol(mesh2$vb))

  expect_warning(expect_s3_class(quad_graticule(n = 20, ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d"))


})

test_that("hull_graticule works", {
  mesh <- hull_graticule() %>% expect_s3_class( "mesh3d")

  expect_warning(hull_graticule(xlim = c(10, 20)))
  expect_warning(hull_graticule(ylim = c(-80, -70)))
  expect_warning(hull_graticule(xlim = c(100, 150), ylim = c(-80, -70)))

  expect_warning(hull_graticule(hull = TRUE))
  expect_warning(hull_graticule(xlim = c(10, 20),hull = TRUE))
  expect_warning(hull_graticule(ylim = c(-80, -70),hull = TRUE))
  expect_warning(hull_graticule(xlim = c(100, 150), ylim = c(-80, -70),hull = TRUE))


  expect_warning(expect_s3_class(hull_graticule(hull = TRUE, sub = 1), "mesh3d"))

  expect_warning(expect_s3_class(hull_graticule(ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d"))

  mesh2 <- hull_graticule(n_coords = 15) %>% expect_s3_class( "mesh3d")
  expect_true(ncol(mesh$vb) > ncol(mesh2$vb))

  expect_warning(expect_s3_class(hull_graticule(n_coords = 20, ylim = c(-80, -70), sub = 2, hull = TRUE), "mesh3d"))


  expect_warning(hull_graticule(n_coords = 10, coords = geosphere::randomCoordinates(100)))
})

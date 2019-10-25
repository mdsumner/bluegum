.onAttach <- function(libname, pkgname) {
  if (!capabilities()[["X11"]] || !capabilities()[["quartz"]]) {
   packageStartupMessage("Welcome to bluegum, no X11 or quartz device detected\n you should run rglwidget() from rgl *after plotting* to visualize 3D outputs")
  }
  invisible(NULL)
}

C2PO R language bindings
========================

[C2PO](http://keminglabs.com/c2po/) is a grammar of graphics implementation inspired by Hadley Wickham's ggplot2 library.
This R package uses the free online C2PO compiler and is limited to 1 MB of data.
Plot specifications are compiled directly to an SVG string, which is returned:

```r
library(c2po)

spec = list(
  data = data.frame(this=rnorm(5, 20), that=rnorm(5, 10))
, mapping = list(x = "this", y = "that")
, geom = "point"
)

c2po(spec) #=> "<svg ..."
```

This is an *experimental* package; the package API, plot specification syntax, and remote server may change or disappear at any time.


Install
-------

Install from Github via the [devtools package](https://github.com/hadley/devtools/):

```r
library(devtools)
devtools::install_github("c2po-r", username = "keminglabs")
```

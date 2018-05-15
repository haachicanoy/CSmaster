# Foundations of computer vision
# By: Harold Achicanoy
# Universidad del Valle, 2018

## R options
g <- gc(reset = T); rm(list = ls()); options(warn = -1); options(scipen = 999)

## Load packages
library(pacman)
pacman::p_load(tiff, png, jpeg, raster, RStoolbox, gridExtra, tidyverse, schoolmath, imager)

## Images directory
# photos <- list.files(path = "./_bean_seeds/_photos/", full.names = T)
# photos <- list.files(path = "./_bean_seeds/_segmented_photos", full.names = T)

## Base functions
## 1). Read images: identify format
image_read <- function(file = "./photos/IMG_5901.JPG"){
  aux <- imager::load.image(file)[,,1][1,1]
  if(schoolmath::is.decimal(aux)){
    img <- imager::load.image(file) * 255
  } else {
    img <- imager::load.image(file)
  }
  return(img)
}
img <- image_read(file = "./_test_images/elephant.jpg")
ggRGB(raster::brick(raster(t(img[,,1])), raster(t(img[,,2])), raster(t(img[,,3]))), 1, 2, 3, stretch = "lin", q = 0)

## Introduction slides
## 2). Sampling: down-sampling
image_sampling <- function(img = img){
  
  img_c1 <- matrix(data = NA, nrow = dim(img)[1]/2, ncol = dim(img)[2]/2, byrow = T)
  img_c2 <- matrix(data = NA, nrow = dim(img)[1]/2, ncol = dim(img)[2]/2, byrow = T)
  img_c3 <- matrix(data = NA, nrow = dim(img)[1]/2, ncol = dim(img)[2]/2, byrow = T)
  
  img.1 <- img[,,1]
  img.2 <- img[,,2]
  img.3 <- img[,,3]
  
  range1 <- seq(1, dim(img.1)[1], 2)
  range2 <- seq(1, dim(img.1)[2], 2)
  
  for(i in 1:length(range1)){
    
    for(j in 1:length(range2)){
      
      img_c1[i,j] <- max(img.1[range1[i]:(range1[i]+1), range2[j]:(range2[j]+1)])
      img_c2[i,j] <- max(img.2[range1[i]:(range1[i]+1), range2[j]:(range2[j]+1)])
      img_c3[i,j] <- max(img.3[range1[i]:(range1[i]+1), range2[j]:(range2[j]+1)])
      
    }
    
  }
  
  r <- raster::raster(t(img_c1)) # Red
  g <- raster::raster(t(img_c2)) # Green
  b <- raster::raster(t(img_c3)) # Blue
  img_r <- raster::brick(r, g, b)
  names(img_r) <- c("r", "g", "b")
  
  return(img_r)
  
}
img_s <- image_sampling(img = img)
ggRGB(img_s, 1, 2, 3, stretch = "lin", q = 0)

## 3). Quantization: linear quantization 8 to 4 bits
# 0   - 15  -> 0
# 16  - 31  -> 1
# ...
# 240 - 255 -> 16
image_quantization <- function(img = img){
  
  img.1 <- img[,,1]
  img.2 <- img[,,2]
  img.3 <- img[,,3]
  
  bits8 <- seq(0, 255, 1)
  bits8_cuttoff <- seq(0, 255, 15)
  
  img.1_q <- matrix(data = as.numeric(as.character(cut(x = img.1, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  img.2_q <- matrix(data = as.numeric(as.character(cut(x = img.2, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  img.3_q <- matrix(data = as.numeric(as.character(cut(x = img.3, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  
  r <- raster::raster(t(img.1_q)) # Red
  g <- raster::raster(t(img.2_q)) # Green
  b <- raster::raster(t(img.3_q)) # Blue
  img_r <- raster::brick(r, g, b)
  names(img_r) <- c("r", "g", "b")
  
  return(img_r)
  
}
img_q <- image_quantization(img = img)
ggRGB(img_q, 1, 2, 3, stretch = "lin", q = 0)

## 4). Color transformations: RGB to CIE XYZ
rgb2xyz <- function(img = img){
  
  x <- 0.412453 * img[,,,1] + 0.357580 * img[,,,2] + 0.180423 * img[,,,3]
  y <- 0.212671 * img[,,,1] + 0.715160 * img[,,,2] + 0.072169 * img[,,,3]
  z <- 0.019334 * img[,,,1] + 0.119193 * img[,,,2] + 0.950277 * img[,,,3]
  
  X <- raster::raster(t(x)) # Red
  Y <- raster::raster(t(y)) # Green
  Z <- raster::raster(t(z)) # Blue
  img_xyz <- raster::brick(X, Y, Z)
  names(img_xyz) <- c("X", "Y", "Z")
  
  return(img_xyz)
  
}
img_XYZ <- rgb2xyz(img = img)
ggRGB(img_XYZ, 1, 2, 3, stretch = "lin", q = 0)
# For test
plot(imager::RGBtoXYZ(im = img))

## 5). Color transformations: CIE XYZ to CIE L*a*b*
img_XYZ2 <- imager::RGBtoXYZ(im = img)
xyz2Lab <- function(img = img){
  
  f_function <- function(z){
    delta <- 6/29
    if(z > delta^3){
      return(z^(1/3))
    } else {
      z/(3*delta^2) + (2 * delta)/3
    }
  }
  
  L <- 116 * f_function(z = img[,,,2]/max(img[,,,2]))
  a <- 500 * (f_function(z = img[,,,1]/max(img[,,,1])) - f_function(z = img[,,,2]/max(img[,,,2])))
  b <- 200 * (f_function(z = img[,,,2]/max(img[,,,2])) - f_function(z = img[,,,3]/max(img[,,,3])))
  
  l <- raster::raster(t(L)) # Red
  a <- raster::raster(t(a)) # Green
  b <- raster::raster(t(b)) # Blue
  img_lab <- raster::brick(l, a, b)
  names(img_lab) <- c("L", "a", "b")
  
  return(img_lab)
}
img_Lab <- xyz2Lab(img = img_XYZ2)
ggRGB(img_Lab, 1, 2, 3, stretch = "lin", q = 0)
# For test
plot(imager::XYZtoLab(im = img_XYZ2))

## 5). Color transformations: CIE XYZ to CIE LUV
img_XYZ2 <- imager::RGBtoXYZ(im = img)
xyz2LUV <- function(img = img){
  
  L <- 116 * (img[,,,2]/max(img[,,,2]))^(1/3) - 16
  u <- 13 * L * (4 * img[,,,1]/(img[,,,1] + 15 * img[,,,2] + 3 * img[,,,3]) - 0.2009)
  v <- 13 * L * (9 * img[,,,2]/(img[,,,1] + 15 * img[,,,2] + 3 * img[,,,3]) - 0.4610)
  
  L <- raster::raster(t(L)) # Red
  U <- raster::raster(t(u)) # Green
  V <- raster::raster(t(v)) # Blue
  img_LUV <- raster::brick(L, U, V)
  names(img_LUV) <- c("L", "U", "V")
  
  return(img_LUV)
  
}
img_LUV <- xyz2LUV(img = img_XYZ2)
ggRGB(img_LUV, 1, 2, 3, stretch = "lin", q = 0)

## 6). Color transformation: RGB to YCbCr
rgb2YCbCr <- function(img = img){
  
  Y <- 0.299 * img[,,,1] + 0.587 * img[,,,2] + 0.114 * img[,,,3]
  Cb <- (img[,,,3] - Y)/1.772 + 0.5
  Cr <- (img[,,,1] - Y)/1.402 + 0.5
  
  Y <- raster::raster(t(Y)) # Red
  Cb <- raster::raster(t(Cb)) # Green
  Cr <- raster::raster(t(Cr)) # Blue
  img_YCbCr <- raster::brick(Y, Cb, Cr)
  names(img_YCbCr) <- c("Y", "Cb", "Cr")
  
  return(img_YCbCr)
  
}
img_YCbCr <- rgb2YCbCr(img = img)
ggRGB(img_YCbCr, 1, 2, 3, stretch = "lin", q = 0)

## 7). Color transformations: RGB to HSV and HSL
rgb2HSV <- function(img = img){
  
  h_function <- function(R, G, B){
    
    M <- max(R, G, B)
    m <- min(R, G, B)
    C <- M - m
    
    if(C == 0){
      return(NA)
    }
    if(M == R){
      return(((G - B)/C) %% 6)
    }
    if(M == G){
      return(((B - R)/C) + 2)
    }
    if(M == B){
      return(((R - G)/C) + 4)
    }
    
  }
  H <- matrix(data = NA, nrow = nrow(img), ncol = ncol(img))
  for(i in 1:nrow(img)){
    for(j in 1:ncol(img)){
      H[i, j] <- h_function(R = img[,,,1][i, j], G = img[,,,2][i, j], B = img[,,,3][i, j])
    }
  }; rm(i, j)
  H <- 60 * H
  V <- M
  
}

plot(RGBtoXYZ(img)) # XYZ
plot(XYZtoLab(RGBtoXYZ(img))) # Lab
plot(RGBtoYUV(img)) # YUV
plot(RGBtoYCbCr(img)) # YCbCr
plot(RGBtoHSV(img)) # HSV
plot(RGBtoHSL(img)) # HSL

## Noise reduction
## Generate kernel function
generate_kernel <- function(values = values, size = 3){
  kernel <- matrix(data = values, nrow = size, ncol = size, byrow = T)
  plot(raster::raster(kernel))
  return(kernel)
}

## Generate convolution function
image_convolution <- function(img = img, kernel = kernel, rgb = "no"){
  
  k.size <- ncol(kernel)
  
  if(rgb == "yes"){
    
    img.1 <- img[,,1]
    img.2 <- img[,,2]
    img.3 <- img[,,3]
    
    img_conv1 <- img.1; img_conv1[] <- NA
    img_conv2 <- img.2; img_conv2[] <- NA
    img_conv3 <- img.3; img_conv2[] <- NA
    
    # as.numeric(img[,,1][1:2, 1:2]) %*% as.numeric(kernel)
    # as.numeric(img[,,1][1:3, 1:3]) %*% as.numeric(kernel)
    
    range1 <- seq(1, dim(img_conv1)[1]-(k.size-1))
    range2 <- seq(1, dim(img_conv1)[2]-(k.size-1))
    
    for(i in range1){
      
      for(j in range2){
        
        img_conv1[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.1[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        img_conv2[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.2[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        img_conv3[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.3[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        
      }
      
    }
    
    r <- raster::raster(t(img_conv1)) # Red
    g <- raster::raster(t(img_conv2)) # Green
    b <- raster::raster(t(img_conv3)) # Blue
    img_conv <- raster::brick(r, g, b)
    names(img_conv) <- c("r", "g", "b")
    
    return(img_conv)
    
  } else {
    if(rgb == "no"){
      
      img.2 <- img[,,2]
      
      img_conv2 <- img.2; img_conv2[] <- NA
      
      # as.numeric(img[,,1][1:2, 1:2]) %*% as.numeric(kernel)
      # as.numeric(img[,,1][1:3, 1:3]) %*% as.numeric(kernel)
      
      range1 <- seq(1, dim(img_conv2)[1]-(k.size-1))
      range2 <- seq(1, dim(img_conv2)[2]-(k.size-1))
      
      for(i in range1){
        
        for(j in range2){
          
          img_conv2[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.2[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
          
        }
        
      }
      
      g <- raster::raster(t(img_conv2)) # Green
      img_conv <- g
      names(img_conv) <- c("g")
      
      return(img_conv)
      
    }
  }
  
  
}

## 8). Mean filter
mean_filter <- function(size){
  values <- rep(1, size * size)/size
  return(values)
}
meanFilter  <- generate_kernel(values = mean_filter(size = 3), size = 3)
img_mean_filter <- image_convolution(img = img, kernel = meanFilter, rgb = "no")
ggRGB(img_mean_filter, r = NULL, g = 1, b = NULL, stretch = "lin", q = 0)

## 9). Gaussian filter
gaussian_filter <- function(sigma = 1, k.size = 5){
  kernel <- matrix(data = NA, nrow = k.size, ncol = k.size, byrow = T)
  indices <- 1:k.size-median(1:k.size)
  for(i in 1:length(indices)){
    for(j in 1:length(indices)){
      kernel[i, j] <- (1/(2*pi*sigma^2)) * exp(-((indices[i]^2 + indices[j]^2)/(2*sigma^2)))
    }
  }
  return(kernel)
}
gaussianFilter <- gaussian_filter(sigma = 1, k.size = 5)
img_gaussian_filter <- image_convolution(img = img, kernel = gaussianFilter, rgb = "no")
ggRGB(img_gaussian_filter, r = NULL, g = 1, b = NULL, stretch = "lin", q = 0)

## 10). Sigma filter

## 11). Nagao-Matsuyama filter

## 12). Median filter
median_filter_convolution <- function(img = img, k.size = k.size, rgb = "no"){
  
  k.size <- k.size
  
  if(rgb == "yes"){
    
    img.1 <- img[,,1]
    img.2 <- img[,,2]
    img.3 <- img[,,3]
    
    img_conv1 <- img.1; img_conv1[] <- NA
    img_conv2 <- img.2; img_conv2[] <- NA
    img_conv3 <- img.3; img_conv2[] <- NA
    
    # as.numeric(img[,,1][1:2, 1:2]) %*% as.numeric(kernel)
    # as.numeric(img[,,1][1:3, 1:3]) %*% as.numeric(kernel)
    
    range1 <- seq(1, dim(img_conv1)[1]-(k.size-1))
    range2 <- seq(1, dim(img_conv1)[2]-(k.size-1))
    
    for(i in range1){
      
      for(j in range2){
        
        img_conv1[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.1[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        img_conv2[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.2[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        img_conv3[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.3[i:(i+(k.size-1)), j:(j+(k.size-1))]) %*% as.numeric(kernel)
        
      }
      
    }
    
    r <- raster::raster(t(img_conv1)) # Red
    g <- raster::raster(t(img_conv2)) # Green
    b <- raster::raster(t(img_conv3)) # Blue
    img_conv <- raster::brick(r, g, b)
    names(img_conv) <- c("r", "g", "b")
    
    return(img_conv)
    
  } else {
    if(rgb == "no"){
      
      img.2 <- img[,,2]
      
      img_conv2 <- img.2; img_conv2[] <- NA
      
      # as.numeric(img[,,1][1:2, 1:2]) %*% as.numeric(kernel)
      # as.numeric(img[,,1][1:3, 1:3]) %*% as.numeric(kernel)
      
      range1 <- seq(1, dim(img_conv2)[1]-(k.size-1))
      range2 <- seq(1, dim(img_conv2)[2]-(k.size-1))
      
      for(i in range1){
        
        for(j in range2){
          
          img_conv2[median(i:(i+(k.size-1))), median(j:(j+(k.size-1)))] <- as.numeric(img.2[i:(i+(k.size-1)), j:(j+(k.size-1))]) %>% median(., na.rm = T)
          
        }
        
      }
      
      g <- raster::raster(t(img_conv2)) # Green
      img_conv <- g
      names(img_conv) <- c("g")
      
      return(img_conv)
      
    }
  }
  
  
}
img_median_filter <- median_filter_convolution(img = img, k.size = 5, rgb = "no")
ggRGB(img_median_filter, r = NULL, g = 1, b = NULL, stretch = "lin", q = 0)


## Histogram slides
## 1.1). Histogram gray-scale
imager::grayscale(im = img) %>% plot
imager::grayscale(im = img) %>% hist(main = "Gray-levels histogram", prob = T)

## 1.2). Histogram color-scale
img_df <- as.data.frame(img)
img_df <- plyr::mutate(img_df, channel = factor(cc, labels = c('R','G','B')))
img_df %>% ggplot(aes(value, fill = channel)) + geom_histogram(bins = 30) + facet_wrap(~ channel)

## 2). Geometric transformations
## Translation
## Rotation
## Scaling changes
## Reflection

## 3). Thresholding
## 3.1). Isodata
img_bin <- img_gray %>% as.array %>% .[,,,1] > autothresholdr::auto_thresh(int_arr = img_gray %>% as.integer, method = "IsoData")
img_bin <- img_bin %>% as.cimg(dim = dim(img_gray))
img_bin %>% plot

## 3.2). Otsu
# img_bin <- img_gray %>% as.array %>% .[,,,1] > EBImage::otsu(x = img_gray %>% as.array %>% .[,,,1], range = c(0, 255))
# img_bin <- img_bin %>% as.cimg(dim = dim(img_gray))
# img_bin %>% plot
img_bin <- img_gray %>% as.array %>% .[,,,1] > autothresholdr::auto_thresh(int_arr = img_gray %>% as.integer, method = "Otsu")
img_bin <- img_bin %>% as.cimg(dim = dim(img_gray))
img_bin %>% plot

## 3.3). Renyi Entropy
img_bin <- img_gray %>% as.array %>% .[,,,1] > autothresholdr::auto_thresh(int_arr = img_gray %>% as.integer, method = "RenyiEntropy")
img_bin <- img_bin %>% as.cimg(dim = dim(img_gray))
img_bin %>% plot

## 3.4). Moments
img_bin <- img_gray %>% as.array %>% .[,,,1] > autothresholdr::auto_thresh(int_arr = img_gray %>% as.integer, method = "Moments")
img_bin <- img_bin %>% as.cimg(dim = dim(img_gray))
img_bin %>% plot

## 4). Visual perception
## Contrast

## 5). Histogram equalization
img_gray <- imager::grayscale(img)
f <- ecdf(img_gray)
plot(f, main = "Empirical CDF of luminance values")

f(img_gray) %>% hist(main="Transformed luminance values")
par(mfrow = c(1, 2))
img_gray %>% plot
f(img_gray) %>% as.cimg(dim = dim(img_gray)) %>% plot(main = "With histogram equalisation")







# Gaussian filter
kernel <- gaussian_filter(sigma = 1, k.size = 5)
img_gaussian <- image_convolution(img = img, kernel = kernel, rgb = "no")
img_gaussian <- asxas
# X sobel
kernel <- generate_kernel(values = c(-1, 0, 1,
                                     -2, 0, 2,
                                     -1, 0, 1), size = 3)
Sx <- image_convolution(img = img_gaussian, kernel = kernel, rgb = "no")
# Y sobel
kernel <- generate_kernel(values = c(-1, -2, -1,
                                     0, 0, 0,
                                     1, 2, 1), size = 3)
Sy <- image_convolution(img = img, kernel = kernel, rgb = "no")

# Magnitud del gradiente
G1 <- abs(Sx) + abs(Sy)
plot(G1)
G2 <- sqrt((Sx * Sx) + (Sy * Sy))
plot(G2)

dim(as.matrix(G))

EBImage::otsu(as.matrix(G), range = c(0, 1), levels = 1064)
library(autothresholdr)
otsu <- autothresholdr::auto_thresh(int_arr = as.matrix(G)[-c(1,224),-c(1, 224)], method = "Otsu")
G[G[] <= otsu] <- 0
G[G[] > otsu] <- 1
plot(G)

plot(as.numeric(names(table(G1[]))), table(G1[]), ty = "h")


# ======================================================================================== #
# Edge detector
# ======================================================================================== #

# 1. Denoising
library(imager)
im <- grayscale(boats) %>% isoblur(2)

# 2. Computing the image gradient, its magnitude and angle
gr <- imgradient(im, "xy")
plot(gr, layout = "row")

# Gradient magnitude
mag <- with(gr, sqrt(x^2+y^2))
plot(mag)

# Gradient angle
ang <- with(gr, atan2(y, x))
plot(ang)

cs <- scales::gradient_n_pal(c("red", "darkblue", "lightblue", "red"), c(-pi, -pi/2, pi/2, pi))
plot(ang, colourscale = cs, rescale = FALSE)


# ======================================================================================== #
# Morphological operations
# ======================================================================================== #
library(EBImage)

grayscale(boats) %>% plot

x = readImage(system.file("images", "shapes.png", package="EBImage"))
kern = makeBrush(5, shape='diamond')  

display(x)
display(kern, title='Structuring element')
display(erode(x, kern), title='Erosion of x')
display(dilate(x, kern), title='Dilatation of x')

## makeBrush
display(makeBrush(99, shape='diamond'))
display(makeBrush(99, shape='disc', step=FALSE))
display(2000*makeBrush(99, shape='Gaussian', sigma=10))

# Texture descriptors

require(raster)
# Calculate GLCM textures using default 90 degree shift
textures_shift1 <- glcm(raster(L5TSR_1986, layer=1))
plot(textures_shift1)

# Calculate GLCM textures over all directions
textures_all_dir <- glcm(raster(L5TSR_1986, layer=1),
                         shift=list(c(0,1), c(1,1), c(1,0), c(1,-1)))
plot(textures_all_dir)


test <- glcm(x = as.matrix(im), shift=list(c(0,1), c(1,1), c(1,0), c(1,-1)))
plot(test)



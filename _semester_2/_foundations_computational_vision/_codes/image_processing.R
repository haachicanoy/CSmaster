# Image processing
# By: Harold Achicanoy
# 2018

# R options
g <- gc(); rm(list = ls()); 

# Load packages
library(tiff)
library(png)
library(jpeg)
library(raster)
library(RStoolbox)
library(gridExtra)
library(imager)
library(schoolmath)

photos <- list.files(path = "./photos", full.names = T)
photos <- list.files(path = "./segmented_photos", full.names = T)

# Read images: identify format
image_read <- function(file = "./photos/IMG_5901.JPG"){
  aux <- imager::load.image(file)[,,1][1,1]
  if(schoolmath::is.decimal(aux)){
    img <- imager::load.image(file) * 255
  } else {
    img <- imager::load.image(file)
  }
  return(img)
}
img <- image_read(file = photos[1])
plot(img)


# Sampling to the middle
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
  
  r <- raster::raster(img_c1) # Red
  g <- raster::raster(img_c2) # Green
  b <- raster::raster(img_c3) # Blue
  img_r <- raster::brick(r, g, b)
  names(img_r) <- c("r", "g", "b")
  
  return(img_r)
  
}
img_s <- image_sampling(img = img)
ggRGB(img_s, 1, 2, 3, stretch = "lin", q = 0)


# Quantization
# 0-15 -> 0
# 16-31 -> 1
# ...
# 240-255 -> 16
image_quantization <- function(img = img){
  
  img.1 <- img[,,1]
  img.2 <- img[,,2]
  img.3 <- img[,,3]
  
  bits8 <- seq(0, 255, 1)
  bits8_cuttoff <- seq(0, 255, 15)
  
  img.1_q <- matrix(data = as.numeric(as.character(cut(x = img.1, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  img.2_q <- matrix(data = as.numeric(as.character(cut(x = img.2, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  img.3_q <- matrix(data = as.numeric(as.character(cut(x = img.3, bits8_cuttoff, 0:16))), nrow = dim(img.1)[1], ncol = dim(img.1)[2], byrow = F)
  
  r <- raster::raster(img.1_q) # Red
  g <- raster::raster(img.2_q) # Green
  b <- raster::raster(img.3_q) # Blue
  img_r <- raster::brick(r, g, b)
  names(img_r) <- c("r", "g", "b")
  
  return(img_r)
  
}
img_q <- image_quantization(img = img)
ggRGB(img_q, 1, 2, 3, stretch = "lin", q = 0)

# Convolution
generate_kernel <- function(values = values, size = 3){
  kernel <- matrix(data = values, nrow = size, ncol = size, byrow = T)
  plot(raster::raster(kernel))
  return(kernel)
}
# Sharpen
kernel <- generate_kernel(values = c(0, -1, 0,
                                     -1, 5, -1,
                                     0, -1, 0), size = 3)
# Blur
kernel <- generate_kernel(values = c(0.0625, 0.125, 0.0625,
                                     0.125, 0.25, 0.125,
                                     0.0625, 0.125, 0.0625), size = 3)
# Bottom sobel
kernel <- generate_kernel(values = c(-1, -2, -1,
                                     0, 0, 0,
                                     1, 2, 1), size = 3)
image_convolution <- function(img = img, kernel = kernel){
  
  k.size <- ncol(kernel)
  
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
  
  r <- raster::raster(img_conv1) # Red
  g <- raster::raster(img_conv2) # Green
  b <- raster::raster(img_conv3) # Blue
  img_conv <- raster::brick(r, g, b)
  names(img_conv) <- c("r", "g", "b")
  
  return(img_conv)
  
}
img_conv <- image_convolution(img = img, kernel = kernel)
ggRGB(img_conv, 1, 2, 3, stretch = "lin", q = 0)


# Generate Gaussian filter
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
kernel <- gaussian_filter(sigma = 3, k.size = 3)
img_conv <- image_convolution(img = img, kernel = kernel)
ggRGB(img_conv, 1, 2, 3, stretch = "lin", q = 0)

# setwd("E:/Buenas-1342/Iguales/P_abajo")
# photos <- list.files(path = ".", full.names = T)
photos <- photos[grep(pattern = "*.JPG$", x = photos)]

photos_raster <- lapply(photos, function(x){
# img <- jpeg::readJPEG(source = x, native = F)
  x = photos[1]
	img <- imager::load.image(x) * 255
	dim(img)
	img <- imager::resize(img, 250, 250)
	r <- raster::raster(img[,,1]) # Red
	g <- raster::raster(img[,,2]) # Green
	b <- raster::raster(img[,,3]) # Blue
	img_r <- raster::brick(r, g, b)
	names(img_r) <- c("r", "g", "b")
	return(img_r)
})

# ggRGB(img_r, 1, 2, 3)
# rpc <- RStoolbox::rasterPCA(img_r)

gray_rasters <- lapply(photos_raster, function(x){
	grayScale <- x$r - x$b
	return(grayScale)
})
gray_rasters <- raster::brick(gray_rasters)
rpc <- RStoolbox::rasterPCA(gray_rasters)

ggRGB(rpc$map, 1, 2, 3, stretch = "lin", q = 0)
if(require(gridExtra)){
  plots <- lapply(1:3, function(x) ggR(rpc$map, x, geom_raster = TRUE))
  grid.arrange(plots[[1]], plots[[2]], plots[[3]], ncol = 2)
}


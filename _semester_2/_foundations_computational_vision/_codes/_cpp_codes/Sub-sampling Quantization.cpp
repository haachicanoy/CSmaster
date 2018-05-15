void splitRGB() {

    qOriginalImageR = QImage(width, height, qOriginalImage.format());
    qOriginalImageG = QImage(width, height, qOriginalImage.format());
    qOriginalImageB = QImage(width, height, qOriginalImage.format());

    for ( int y = 0; y < height; ++y )
        for ( int x = 0; x < width; ++x ){
            QColor clrCurrent(qOriginalImage.pixel(x, y));
            qOriginalImageR.setPixel(x, y, qRgb(clrCurrent.red(), 0, 0));
            qOriginalImageG.setPixel(x, y, qRgb(0, clrCurrent.green(), 0));
            qOriginalImageB.setPixel(x, y, qRgb(0, 0, clrCurrent.blue()));
    }
}

void subSampling(int value) {

    int subWidth    = width/value;
    int subHeight   = height/value;

    qSampledImage = QImage(subWidth, subHeight, QImage::Format_Grayscale8);

    for(int subY = 0; subY < subHeight; subY++)
        for(int subX = 0; subX < subWidth; subX++){
            int average = 0;
            int initX = (value * subX);
            int initY = (value * subY);
            for(int y = 0; y < value; y++)
                for(int x = 0; x < value; x++){
                    average +=  originalPixels[(initX + x) + ((initY + y) * width)];
                }

            int gray = average / (value * value);
            qSampledImage.setPixel(subX, subY, qRgb(gray, gray, gray));
        }
}

void bitDepthReduction(int bitsToReduce) {

    qBitDepthReducedImage = QImage(width, height, QImage::Format_Grayscale8);

    uchar* reducedPixels = qBitDepthReducedImage.bits();

    // Verify if the image is loaded
    if (bitsToReduce > 8){
        printf("Error in bit depth reduction: valur upper to 8\n");
        exit(EXIT_FAILURE);
    }

    int numberColors = 1 << bitsToReduce;
    int numberGrayScale = 256 / numberColors;
    int maxValue = 255 / numberGrayScale;

    for(int pixel = 0; pixel < (width * height); pixel++)
        reducedPixels[pixel] = ((originalPixels[pixel]/ numberGrayScale) * 255) / maxValue;
}
#include <QApplication>
#include <QImage>
#include <QImageReader>
#include <QFile>
#include <QTextStream>
#include <QPixmap>
#include <QGraphicsScene>
#include <QGraphicsView>
#include <QGraphicsPixmapItem>
#include <QVector>
#include <iostream>

int main(int argc, char *argv[])
{

    // Define path file to load image
    QString fileName = "C:/Users/gomez/Documents/Introduction/jetplane2.jpg";

    // Create Image Read object
    QImageReader reader(fileName);

    //Read Image on device and load QImage object
    QImage image = reader.read();

    if (image.isNull()){
        printf("Invalid Image\n");
        exit(EXIT_FAILURE);
    }

    // Print Image Information (Resolution and bit-depth)
    printf("Image Size: %d x %d to %d bits with format %d\n", image.width(), image.height(), image.depth(), image.format());

    // Image to array (pointer to position of firts pixel in the image)
    uchar* pixels = image.bits();

    // Create File class for writing the pixel information in text file
    QString fileSave = "C:/Users/gomez/Documents/Introduction/Data.csv";
    QFile file(fileSave);
    file.open(QIODevice::ReadWrite);
    QTextStream stream(&file);

    // Write each Pixel of the image
    for(int pixel = 0; pixel < image.width()*image.height();pixel++){
        stream << "" + QString::number(pixels[pixel]) + ";";
        if((pixel % image.width()) == 0 && pixel > 1)
            stream << "\n";
    }

    file.close();

    //Read File with pixel information
    file.open(QIODevice::ReadOnly | QIODevice::Text);

    // read whole file content
    QString content = file.readAll();

    // extract words
    QStringList list = content.split(";");

    // Convert String with the pixel value in integer
    QVector<int> values;
    for(int pixel = 0; pixel < list.size(); pixel++)
        values.append(list.at(pixel).toInt());


    // Create New image and Copy information store in the text file
    QImage newImage(image.width(),image.height(), image.format());

    for(int y = 0; y < newImage.height();y++)
        for(int x = 0; x < newImage.width(); x++){
            int gray =  values.at(x + (y * image.width()));
            newImage.setPixel(x, y, qRgb(gray,gray,gray));
    }

    // Create New Image for read RGB image
    QString fileName2 = "C:/Users/gomez/Documents/Introduction/bear.jpg";

    // Create Image Read object
    QImageReader reader2(fileName2);

    //Read Image on device and load QImage object
    QImage image2 = reader2.read();

    if (image2.isNull()){
        printf("Invalid Image\n");
        exit(EXIT_FAILURE);
    }

    // Print RGB Image Information (Resolution and bit-depth)
    printf("Image Size: %d x %d to %d bits with format %d\n", image2.width(), image2.height(), image2.depth(), image2.format());

    QImage red(image2.width(), image2.height(), image2.format());
    QImage green(image2.width(), image2.height(), image2.format());
    QImage blue(image2.width(), image2.height(), image2.format());

    for ( int y = 0; y < image2.height(); ++y )
        for ( int x = 0; x < image2.width(); ++x ){
            QColor clrCurrent(image2.pixel(x, y));
            red.setPixel(x, y, qRgb(clrCurrent.red(), 0, 0));
            green.setPixel(x, y, qRgb(0, clrCurrent.green(), 0));
            blue.setPixel(x, y, qRgb(0, 0, clrCurrent.blue()));

           // printf("Pixel at [%d, %d] contains color (%d, %d, %d)", x, y, clrCurrent.red(), clrCurrent.green(), clrCurrent.blue());
    }

    // Load widget and show GrayScale Image
    QApplication a(argc, argv);
    QGraphicsScene scene;
    QGraphicsView view(&scene);
    QGraphicsPixmapItem item(QPixmap::fromImage(image));
    scene.addItem(&item);
    view.show();

    // Load widget and show Modified Grayscale Image
    QGraphicsScene sceneNew;
    QGraphicsView viewNew(&sceneNew);
    QGraphicsPixmapItem itemNew(QPixmap::fromImage(newImage));
    sceneNew.addItem(&itemNew);
    viewNew.show();

    // Load widget and Show RGB Image
    QGraphicsScene scene2;
    QGraphicsView view2(&scene2);
    QGraphicsPixmapItem item2(QPixmap::fromImage(image2));
    scene2.addItem(&item2);
    view2.show();

    //Load widget and Show Red Channel of RGB Image
    QGraphicsScene sceneRed;
    QGraphicsView viewRed(&sceneRed);
    QGraphicsPixmapItem itemRed(QPixmap::fromImage(red));
    sceneRed.addItem(&itemRed);
    viewRed.show();

    // Load Widget and Show Green Channel for RGB Image
    QGraphicsScene sceneGreen;
    QGraphicsView viewGreen(&sceneGreen);
    QGraphicsPixmapItem itemGreen(QPixmap::fromImage(green));
    sceneGreen.addItem(&itemGreen);
    viewGreen.show();

    // Load Widget and Show Blue Channel for RGB Image
    QGraphicsScene sceneBlue;
    QGraphicsView viewBlue(&sceneBlue);
    QGraphicsPixmapItem itemBlue(QPixmap::fromImage(blue));
    sceneBlue.addItem(&itemBlue);
    viewBlue.show();

    // Execute the application (For widgets)
    return a.exec();

}

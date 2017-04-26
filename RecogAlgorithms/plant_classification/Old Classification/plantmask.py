import cv2
import argparse
import imutils
import numpy as np
from matplotlib import pyplot as plt
from PIL import Image


# Reads in argument
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True, help="path to the input image")
args = vars(ap.parse_args())

# Runs Canny Edge Detection
image = cv2.imread(args["image"])
imgray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(imgray, 50, 150)
contourImage = cv2.Canny(imgray, 50, 150)

image, contours, hierarchy = cv2.findContours(edges,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
finish = cv2.drawContours(contourImage, contours, -1, (255,255,255), 3)

#im = Image.fromarray(np.uint8(contourImage*255))

#im = Image.fromarray(imgray, 'RGB')
#im.show()


#cv2.imshow("Image", contourImage)
#cv2.waitKey(0)

#plt.subplot(121),plt.imshow(image,cmap = 'gray')
#plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(edges,cmap = 'gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])

plt.show()

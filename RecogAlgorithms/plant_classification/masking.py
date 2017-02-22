# USAGE
# python masking.py --image ../images/beach.png

# Import the necessary packages
import numpy as np
import argparse
import cv2
from PIL import Image

# Construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True,
	help = "Path to the image")
args = vars(ap.parse_args())

# Load the image and show it
img = cv2.imread(args["image"])
#cv2.imshow("Original", image)
#blur = cv2.blur(image, (5,5))
#gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
ret, thresh = cv2.threshold(img,127,255,0)
image, contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
cont = cv2.drawContours(, contours, -1, (0,255,0),3)
im = Image.fromarray(np.uint8(cont*255))
im.show()


# Masking allows us to focus only on parts of an image that
# interest us. A mask is the same size as our image, but has
# only two pixel values, 0 and 255. Pixels with a value of 0
# are ignored in the orignal image, and mask pixels with a
# value of 255 are allowed to be kept. For example, let's
# construct a mask with a 150x150 square at the center of it
# and mask our image.
mask = np.zeros(image.shape[:2], dtype = "uint8")
(cX, cY) = (image.shape[1] // 2, image.shape[0] // 2)
cv2.rectangle(mask, (cX - 75, cY - 75), (cX + 75 , cY + 75), 255, -1)
#cv2.show("Mask", mask)

# Apply out mask -- notice how only the center rectangular
# region of the pill is shown
masked = cv2.bitwise_and(image, image, mask = mask)
#cv2.show("Mask Applied to Image", masked)
#cv2.waitKey(0)

# Now, let's make a circular mask with a radius of 100 pixels
mask = np.zeros(image.shape[:2], dtype = "uint8")
cv2.circle(mask, (cX, cY), 100, 255, -1)
masked = cv2.bitwise_and(image, image, mask = mask)

#cv2.show("Mask", mask)
#cv2.show("Mask Applied to Image", masked)
maskImage = Image.fromarray(np.uint8(mask*255))
maskedImage = Image.fromarray(masked, 'RGB')
#maskImage.show()
#maskedImage.show()
#maskedImage.save("masked.png")


#cv2.waitKey(0)

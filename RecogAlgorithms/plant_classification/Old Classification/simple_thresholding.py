# USAGE
# python simple_thresholding.py --image ../images/coins.png

# Import the necessary packages
import numpy as np
import argparse
import cv2
from matplotlib import pyplot as plt
from PIL import Image
import PIL.ImageOps

# Construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True,
	help = "Path to the image")
args = vars(ap.parse_args())

# Load the image, convert it to grayscale, and blur it slightly
image = cv2.imread(args["image"])
image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(image, (5, 5), 0)

# Let's apply basic thresholding. The first parameter is the
# image we want to threshold, the second value is is our threshold
# cehck. If a pixel value is greater than our threshold (in this
# case, 155), we it to be WHITE, otherwise it is BLACK.
(T, threshInv) = cv2.threshold(blurred, 155, 255, cv2.THRESH_BINARY_INV)
#(T, threshInv) = cv2.threshold(blurred, 155, 255, cv2.THRESH_BINARY_INV)
#cv2.imshow("Threshold Binary Inverse", threshInv)
threshInv = Image.fromarray(threshInv)
threshInv = threshInv.convert('1')
threshInv = threshInv.convert('L')
inverted_image = PIL.ImageOps.invert(threshInv)
inverted_image = inverted_image.convert('1')
inverted_image.show()


# Using a normal we can change the last argument in the function
# to make the coins black rather than white.
(T, thresh) = cv2.threshold(blurred, 155, 255, cv2.THRESH_BINARY)
#cv2.imshow("Threshold Binary", thresh)

# Finally, let's use our threshold as a mask and visualize only
# the coins in the image
#cv2.imshow("Coins", cv2.bitwise_and(image, image, mask = threshInv))
#cv2.waitKey(0)

# python classify.py --images dataset/images --masks dataset/masks

# All photos that are used for -p have to be .png

# import the necessary packages
from __future__ import print_function
from pyimagesearch.rgbhistogram import RGBHistogram
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
#from sklearn.cross_validation import train_test_split
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
import numpy as np
import argparse
import glob
import cv2
import PIL.ImageOps
from PIL import Image
from matplotlib import pyplot as plt
import mahotas


# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--images", required = True,
	help = "path to the image dataset")
ap.add_argument("-m", "--masks", required = True,
	help = "path to the image masks")
# Add a single photo to be recognized
ap.add_argument("-p", "--photo", required = True,
	help = "path to the single photo")

args = vars(ap.parse_args())

# grab the image and mask paths
imagePaths = sorted(glob.glob(args["images"] + "/*.png"))
maskPaths = sorted(glob.glob(args["masks"] + "/*.png"))

# Printing original input image
#oImage = Image.open(args["photo"])
#oImage.show()
print("\n Analyzing picture, now loading... \n")

# Resizing the image
image = cv2.imread(args["photo"])
r = 400.0 / image.shape[1]
dim = (400, int(image.shape[0] * r))
resized = cv2.resize(image, dim, interpolation = cv2.INTER_AREA)
blurred = cv2.GaussianBlur(resized, (5,5),0)
T = mahotas.thresholding.otsu(blurred)
print('Otsus threshold: %d' % T)
thresh = image.copy()
thresh[thresh > T] = 255
thresh[thresh < 255] = 0
thresh = cv2.bitwise_not(thresh)

mPreview = Image.fromarray(thresh)
mPreview.show()

V = mahotas.thresholding.rc(blurred)
print('Riddler-Calvard: %d' % V)
thresh = image.copy()
thresh[thresh > V] = 255
thresh[thresh < 255] = 0
thresh = cv2.bitwise_not(thresh)

mPreview = Image.fromarray(thresh)
mPreview.show()





"""
# initialize the list of data and class label targets
data = []
target = []

# initialize the image descriptor
desc = RGBHistogram([8, 8, 8])

# loop over the image and mask paths
for (imagePath, maskPath) in zip(imagePaths, maskPaths):
	# load the image and mask
    image = cv2.imread(imagePath)
	mask = cv2.imread(maskPath)
	mask = cv2.cvtColor(mask, cv2.COLOR_BGR2GRAY)

	# describe the image
	features = desc.describe(image, mask)

	# update the list of data and targets
	data.append(features)
	target.append(imagePath.split("_")[-2])

# grab the unique target names and encode the labels
targetNames = np.unique(target)
le = LabelEncoder()
target = le.fit_transform(target)

# construct the training and testing splits
(trainData, testData, trainTarget, testTarget) = train_test_split(data, target,
	test_size = 0.3, random_state = 42)

# train the classifier
model = RandomForestClassifier(n_estimators = 25, random_state = 84)

model.fit(trainData, trainTarget)

# evaluate the classifier
print(classification_report(testTarget, model.predict(testData),
	target_names = targetNames))


# Getting the Simple Threshold of the image/masking it
maskedImage = cv2.imread(args["photo"])
imgray = cv2.cvtColor(maskedImage, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(imgray, (5, 5), 0)
(T, threshInv) = cv2.threshold(blurred, 155, 255, cv2.THRESH_BINARY_INV)

# Showing a masked version of the input .png file
mPreview = Image.fromarray(threshInv)
mPreview = mPreview.convert('1')
mPreview = mPreview.convert('L')
inverted_image = PIL.ImageOps.invert(mPreview)
inverted_image = inverted_image.convert('1')
inverted_image.show()

# describe the image
features = desc.describe(maskedImage, threshInv)

# predict what type of flower the image is
flower = le.inverse_transform(model.predict([features]))[0]
print("I think this flower is a {}".format(flower.upper()))
"""

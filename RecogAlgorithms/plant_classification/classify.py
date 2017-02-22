# USAGE
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
from PIL import Image
from matplotlib import pyplot as plt

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--images", required = True,
	help = "path to the image dataset")
ap.add_argument("-m", "--masks", required = True,
	help = "path to the image masks")

# Add a single photo to be recognized
ap.add_argument("-p", "--photo", required = True,
	help = "path to the single photo")
#ap.add_argument("-n", "--photomask", required = True,
#	help = "path to photo mask")
args = vars(ap.parse_args())

# grab the image and mask paths
imagePaths = sorted(glob.glob(args["images"] + "/*.png"))
maskPaths = sorted(glob.glob(args["masks"] + "/*.png"))

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


# WAY1: Getting the mask of the image
#maskedImage = cv2.imread(args["photo"])
#mask = np.zeros(image.shape[:2], dtype = "uint8")
#(cX, cY) = (image.shape[1] // 2, image.shape[0] // 2)
#cv2.rectangle(mask, (cX - 75, cY - 75), (cX + 75 , cY + 75), 255, -1)
#masked = cv2.bitwise_and(image, image, mask = mask)
#mask = np.zeros(image.shape[:2], dtype = "uint8")
#cv2.circle(mask, (cX, cY), 100, 255, -1)
#masked = cv2.bitwise_and(image, image, mask = mask)

# WAY2: Getting the mask of the image
maskedImage = cv2.imread(args["photo"])
imgray = cv2.cvtColor(maskedImage,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(imgray, 50, 150)
contourImage = cv2.Canny(imgray, 50, 150)
image, contours, hierarchy = cv2.findContours(edges,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
cv2.drawContours(contourImage, contours, -1, (255,255,255), 3)

# describe the image
features = desc.describe(maskedImage, contourImage)

# predict what type of flower the image is
flower = le.inverse_transform(model.predict([features]))[0]
print("I think this flower is a {}".format(flower.upper()))

# Show Mask of flower
plt.subplot(122),plt.imshow(edges,cmap = 'gray')
plt.title('Mask of Image'), plt.xticks([]), plt.yticks([])
plt.show()

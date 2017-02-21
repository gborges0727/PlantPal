# USAGE
# python classify.py --images dataset/images --masks dataset/masks

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

# adding masked image


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

# Grabbing individual photo's path
photopath = sorted(glob.glob(args["photo"] + "/*.png"))
#photomaskpath = sorted(glob.glob(args["photomask"] + "/*.png"))



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

model.fit(trainData, trainTarget)    # <------ Giving an error HERE

# evaluate the classifier
print(classification_report(testTarget, model.predict(testData),
	target_names = targetNames))

# loop over a sample of the images
#for i in np.random.choice(np.arange(0, len(imagePaths)), 10):
	# grab the image and mask paths
	#print(photopath)
	#imagePath =  photopath						    #imagePaths[i]
	#maskPath = 	 photomaskpath						#maskPaths[i]

	# load the image and mask

image = cv2.imread(photopath[0])

# Getting the mask of the image
maskedImage = cv2.imread(args["photo"])
mask = np.zeros(image.shape[:2], dtype = "uint8")
(cX, cY) = (image.shape[1] // 2, image.shape[0] // 2)
cv2.rectangle(mask, (cX - 75, cY - 75), (cX + 75 , cY + 75), 255, -1)
masked = cv2.bitwise_and(image, image, mask = mask)
mask = np.zeros(image.shape[:2], dtype = "uint8")
cv2.circle(mask, (cX, cY), 100, 255, -1)
masked = cv2.bitwise_and(image, image, mask = mask)

#mask = cv2.imread(photomaskpath[0])
mask = cv2.cvtColor(masked, cv2.COLOR_BGR2GRAY)

# describe the image
features = desc.describe(image, mask)

# predict what type of flower the image is
flower = le.inverse_transform(model.predict([features]))[0]
print("I think this flower is a {}".format(flower.upper()))
#cv2.imshow("image", image)
#cv2.waitKey(0)

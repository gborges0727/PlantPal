# Machine Learning Methods used and implemented for UConn's CSE senior design project
# Group Members involved with ML software engineering: Patrick Korianski and Gabe Borges

# import the necessary packages
from __future__ import print_function
from pyimagesearch.rgbhistogram import RGBHistogram
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
#from keras.applications import ResNet50
#from keras.applications import InceptionV3
#from keras.applications import Xception # TensorFlow ONLY
from keras.applications import VGG16
#from keras.applications import VGG19
from keras.applications import imagenet_utils
from keras.applications.inception_v3 import preprocess_input
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import load_img
import numpy as np
import argparse
import glob
import cv2
import PIL.ImageOps
from PIL import Image
import matplotlib 
matplotlib.use('Agg')
from matplotlib import pyplot as plt
#import mahotas
import re

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()

# Add a single photo to be recognized
ap.add_argument("-p", "--photo", required = True,
	help = "path to the single photo")
args = vars(ap.parse_args())

# grab the image and mask paths
imagePaths = sorted(glob.glob("dataset/images" + "/*.png"))
maskPaths = sorted(glob.glob("dataset/masks/" + "/*.png"))

# define a dictionary that maps model names to their classes
# The different types of pretrained neural networks on the datasets in ImageNet
MODELS = {
	"vgg16": VGG16
}

# initialize the list of data and class label targets
data = []
target = []

# initialize the photo descriptor
desc = RGBHistogram([8, 8, 8])

# initialize the input photo shape (224x224 pixels) along with
inputShape = (224, 224)

# the pre-processing function
preprocess = imagenet_utils.preprocess_input

# load our the network weights from disk
# first time, the VGG16 will download to local disk
Network = VGG16
model = Network(weights="imagenet")

# load the input image using the Keras helper utility while ensuring
# the image is resized to `inputShape`
#print("[Photo] is being processed and identified...")
image = load_img(args["photo"], target_size=inputShape)
image = img_to_array(image)

# below, our input photo is represented as a NumPy array of shape
# (inputShape[0], inputShape[1], 3) and then resized to (1, inputShape[0], inputShape[1], 3)
image = np.expand_dims(image, axis=0)

# pre-process the image using the appropriate function based on the
# model that has been loaded (i.e., mean subtraction, scaling, etc.)
image = preprocess(image)

# classify the image
preds = model.predict(image)
P = imagenet_utils.decode_predictions(preds)

# loop over the predictions and display the top ranked choice
# probabilities to our terminal
for (i, (imagenetID, label, prob)) in enumerate(P[0]):
	break

# for testing, I am printing what the label is
#print('Label= %s'%label)

def check():
    # The object string that was found
    w = label
    # opening the file
    with open("flowerwords.txt") as f:
        found = False
        for line in f:
            if w in line:
                found = True
                return found
        if not found:
            return found
r = "ROSE"

def check2():
    # The object string that was found
    w = label
    # opening the file
    with open("xfile.txt") as f:
        found = False
        for line in f:
            if w in line:
                found = True
                return found
        if not found:
            return found

def plantClass(target, data):
	# loop over the image and mask paths
	for (imagePath, maskPath) in zip(imagePaths, maskPaths):
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
	#print(classification_report(testTarget, model.predict(testData),
	#	target_names = targetNames))

	# Getting the Simple Threshold of the image/masking it
	maskedImage = cv2.imread(args["photo"])
	imgray = cv2.cvtColor(maskedImage, cv2.COLOR_BGR2GRAY)
	blurred = cv2.GaussianBlur(imgray, (5, 5), 0)
	(T, threshInv) = cv2.threshold(blurred, 155, 255, cv2.THRESH_BINARY_INV)


	# describe the image
	features = desc.describe(maskedImage, threshInv)

	# predict what type of flower the image is
	flower = le.inverse_transform(model.predict([features]))[0]
	print("{}".format(flower.upper()))

# finding the results
if check():
	plantClass(target, data)
if not check():
	if check2():
		print(r)
	else:
		print("Not a Plant")

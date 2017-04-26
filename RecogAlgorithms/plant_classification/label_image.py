# Modified by Patrick Korianski
# UConn Senior Design 2016-2017
# Tensorflow development

import tensorflow as tf, sys, warnings

# Added this to disable any warnings from the program. Using different versions of the libraries sometimes trigger warnings
warnings.filterwarnings('ignore')

# Getting the picture to classify from the user
image_path = sys.argv[1]

# Reads the image given by the user
image_data = tf.gfile.FastGFile(image_path, 'rb').read()

# Loads label file, strips off carriage return
label_lines = [line.rstrip() for line
                   in tf.gfile.GFile("/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/retrained_labels.txt")]

# Unpersists graph from file
with tf.gfile.FastGFile("/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/retrained_graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')

with tf.Session() as sess:
    # Feed the image_data as input to the graph and get first prediction
    softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')

    predictions = sess.run(softmax_tensor, \
             {'DecodeJpeg/contents:0': image_data})

    # Sort to show labels of first prediction in order of confidence
    top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

    # Prints the top two flowers with the highest precent predictions
    f1Percent = predictions[0][top_k[0]]*100
    notPercent = 100 - predictions[0][top_k[0]]*100

    if (f1Percent > 30.0):
        tPercent = 100 - predictions[0][top_k[1]]*100
        print "%s %.2f %s %.2f"%(label_lines[top_k[0]],tPercent, label_lines[top_k[1]],predictions[0][top_k[1]]*100)
    else:
        print "NotAPlant %.2f %s %.2f"%(notPercent, label_lines[top_k[0]],predictions[0][top_k[0]]*100)

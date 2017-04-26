# Modified by Patrick Korianski
# UConn Senior Design 2016-2017
# Tensorflow development

import tensorflow as tf, sys, warnings

warnings.filterwarnings('ignore')


image_path = sys.argv[1]

# Read in the image_data
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
    f1Percent = predictions[0][top_k[1]]*100

    if (f1Percent > 30.0):
        tPercent = 100 - predictions[0][top_k[1]]*100
        print "%s %.3f %s %.3f"%(label_lines[top_k[0]],tPercent, label_lines[top_k[1]],predictions[0][top_k[1]]*100)
    else:
        print "NotAPlant 100.0 NotAPlant 100.0"    

    # Removed so it does not list all possibilities
    '''
    for node_id in top_k:
        human_string = label_lines[node_id]
        score = predictions[0][node_id]
        print('%s (score = %.5f)' % (human_string, score))
    '''

from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import os
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input

app = Flask(__name__)

MODEL_OUT = os.path.abspath("assets/model/best_combined_classifier.tflite")
interpreter = tf.lite.Interpreter(model_path=MODEL_OUT)
interpreter.allocate_tensors()

class_names = [
    "Fauna_AvesIcterus icterus_images",
    "Fauna_AvesMilvago chimachima_images",
    "Fauna_MamiferosCebus apella_images",
    "Fauna_PecesBrycon whitei_images",
    "Fauna_PecesPiaractus brachypomus_images",
    "Fauna_ReptilesChelonoidis carbonarius_images",
    "Flora_NativaBursera simaruba_images",
    "Flora_NativaHandroanthus chrysanthus_images"
]

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# New prediction function using same logic as test algorithm
def predict_image_tflite(image_bytes, interpreter, class_names):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((224, 224))
    x = np.array(img, dtype=np.float32)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    input_index = interpreter.get_input_details()[0]['index']
    output_index = interpreter.get_output_details()[0]['index']
    interpreter.set_tensor(input_index, x)
    interpreter.invoke()
    preds = interpreter.get_tensor(output_index)[0]
    idx = np.argmax(preds)
    return class_names[idx], float(preds[idx])

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    try:
        img_bytes = file.read()
        class_name, confidence = predict_image_tflite(img_bytes, interpreter, class_names)
        return jsonify({'class': class_name, 'confidence': confidence * 100})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
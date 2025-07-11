import os
import numpy as np
from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from tensorflow.keras.preprocessing import image

# Configuración
MODEL_PATH = "best_fauna_classifier_tf1.h5"  # Cambia a tu modelo si es flora
IMG_SIZE = (224, 224)

# Cargar modelo y clases
model = load_model(MODEL_PATH)

# Si tienes las clases guardadas en un archivo, cámbialo aquí
def get_class_names(dataset_dir):
    # Busca las carpetas de clases en el dataset plano
    classes = [d for d in os.listdir(dataset_dir) if os.path.isdir(os.path.join(dataset_dir, d))]
    classes.sort()
    return classes

# Cambia este path al dataset plano correspondiente
default_dataset_dir = "AugmentedDataset_flat_Fauna"
class_names = get_class_names(default_dataset_dir)

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    try:
        img = image.load_img(file, target_size=IMG_SIZE)
        x = image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)
        preds = model.predict(x)
        class_idx = int(np.argmax(preds, axis=1)[0])
        class_name = class_names[class_idx] if class_idx < len(class_names) else str(class_idx)
        confidence = float(np.max(preds))
        return jsonify({'class': class_name, 'confidence': confidence})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
